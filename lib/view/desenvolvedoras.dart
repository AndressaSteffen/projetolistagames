import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importe o Firebase Firestore

class Desenvolvedora {
  final String nome;
  final String logoUrl;

  Desenvolvedora({required this.nome, required this.logoUrl});

}

class DesenvolvedorasPage extends StatefulWidget {
  @override
  _DesenvolvedorasPageState createState() => _DesenvolvedorasPageState();
}

class _DesenvolvedorasPageState extends State<DesenvolvedorasPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _logoUrlController = TextEditingController();

  // Referência à coleção de desenvolvedoras no Firestore
  final CollectionReference desenvolvedorasCollection = FirebaseFirestore.instance.collection('desenvolvedoras');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desenvolvedoras'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: desenvolvedorasCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Se chegamos aqui, os dados foram carregados com sucesso do Firestore
          List<Desenvolvedora> desenvolvedoras = snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Desenvolvedora(
              nome: data['nome'] ?? '',
              logoUrl: data['logoUrl'],
            );
          }).toList();

          return ListView.builder(
            itemCount: desenvolvedoras.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, right: 10),
                child: ListTile(
                  leading: Image.network(desenvolvedoras[index].logoUrl),
                  title: Text(
                    desenvolvedoras[index].nome,
                    style:TextStyle(
                      color:Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeveloperDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Função para exibir o formulário de adição de desenvolvedora
  void _showAddDeveloperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Desenvolvedora'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Por favor, insira o nome da desenvolvedora';
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
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Crie uma nova instância de Desenvolvedora com os valores inseridos
                  Desenvolvedora novaDesenvolvedora = Desenvolvedora(
                    nome: _nameController.text,
                    logoUrl: _logoUrlController.text,
                  );

                  // Adicione a nova desenvolvedora à coleção no Firestore
                  try {
                    await desenvolvedorasCollection.add({
                      'nome': novaDesenvolvedora.nome,
                      'logoUrl': _logoUrlController.text,
                    });
                    print('Desenvolvedora adicionada com sucesso.');
                  } catch (e) {
                    print('Erro ao adicionar a desenvolvedora: $e');
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
