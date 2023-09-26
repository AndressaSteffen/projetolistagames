import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listagames/model/jogo_model.dart';

class JogosPage extends StatefulWidget {
  @override
  _JogosPageState createState() => _JogosPageState();
}

class _JogosPageState extends State<JogosPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _logoUrlController = TextEditingController();
  TextEditingController _totalHorasController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  TextEditingController _desenvolvedoraIdController = TextEditingController();
  TextEditingController _plataformaIdController = TextEditingController();
  TextEditingController _jogandoController = TextEditingController();
  TextEditingController _terminadoController = TextEditingController();

  // Referência à coleção de jogos no Firestore
  final CollectionReference jogosCollection = FirebaseFirestore.instance.collection('jogos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: jogosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Se chegamos aqui, os dados foram carregados com sucesso do Firestore
          List<Jogo> jogos = snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Jogo(
              id: doc.id,
              nome: data['nome'] ?? '',
              logoUrl: data['logoUrl'] ?? '',
              totalHoras: data['totalHoras'] ?? 0,
              preco: data['preco'] ?? 0.0,
              desenvolvedoraId: data['desenvolvedoraId'] ?? '',
              plataformaId: data['plataformaId'] ?? '',
              jogando: data['jogando'] ?? false,
              terminado: data['terminado'] ?? false,
            );
          }).toList();

          return ListView.builder(
            itemCount: jogos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, left: 5),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: SizedBox(
                    width: 72,
                    child: Image.network(jogos[index].logoUrl),
                  ),
                  title: Text(jogos[index].nome),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGameDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Função para exibir o formulário de adição de jogo
  void _showAddGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Jogo'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira o nome do jogo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _logoUrlController,
                      decoration: InputDecoration(labelText: 'URL do Logo'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira a URL do logo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _totalHorasController,
                      decoration: InputDecoration(labelText: 'Total de Horas'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira o total de horas';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _precoController,
                      decoration: InputDecoration(labelText: 'Preço'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira o preço';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _desenvolvedoraIdController,
                      decoration: InputDecoration(labelText: 'ID da Desenvolvedora'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira o ID da desenvolvedora';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _plataformaIdController,
                      decoration: InputDecoration(labelText: 'ID da Plataforma'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira o ID da plataforma';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _jogandoController,
                      decoration: InputDecoration(labelText: 'Jogando (true/false)'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira se está jogando ou não';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _terminadoController,
                      decoration: InputDecoration(labelText: 'Terminado (true/false)'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor, insira se está terminado ou não';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Crie uma nova instância de Jogo com os valores inseridos
                  Jogo novoJogo = Jogo(
                    id: '',
                    nome: _nomeController.text,
                    logoUrl: _logoUrlController.text,
                    totalHoras: double.parse(_totalHorasController.text),
                    preco: double.parse(_precoController.text),
                    desenvolvedoraId: _desenvolvedoraIdController.text,
                    plataformaId: _plataformaIdController.text,
                    jogando: _jogandoController.text.toLowerCase() == 'true',
                    terminado: _terminadoController.text.toLowerCase() == 'true',
                  );

                  // Adicione o novo Jogo à coleção no Firestore
                  try {
                    await jogosCollection.add({
                      'nome': novoJogo.nome,
                      'logoUrl': novoJogo.logoUrl,
                      'totalHoras': novoJogo.totalHoras,
                      'preco': novoJogo.preco,
                      'desenvolvedoraId': novoJogo.desenvolvedoraId,
                      'plataformaId': novoJogo.plataformaId,
                      'jogando': novoJogo.jogando,
                      'terminado': novoJogo.terminado,
                    });
                    print('Jogo adicionado com sucesso.');
                  } catch (e) {
                    print('Erro ao adicionar o Jogo: $e');
                  }

                  // Feche o diálogo
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}