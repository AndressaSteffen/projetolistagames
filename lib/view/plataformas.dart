import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importe o Firebase Firestore

class Plataforma {
  final String nome;
  final String logoUrl;

  Plataforma({required this.nome, required this.logoUrl});

}

class PlataformasPage extends StatefulWidget {
  @override
  _PlataformasPageState createState() => _PlataformasPageState();
}

class _PlataformasPageState extends State<PlataformasPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _logoUrlController = TextEditingController();

  // Referência à coleção de Plataformas no Firestore
  final CollectionReference plataformasCollection = FirebaseFirestore.instance.collection('plataformas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plataformas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: plataformasCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Se chegamos aqui, os dados foram carregados com sucesso do Firestore
          List<Plataforma> Plataformas = snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Plataforma(
              nome: data['nome'] ?? '',
              logoUrl: data['logoUrl'],
            );
          }).toList();

          return ListView.builder(
            itemCount: Plataformas.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 5, top: 5, left: 5),
                child: ListTile(
                  leading: Image.network(Plataformas[index].logoUrl),
                  title: Text(
                    Plataformas[index].nome,
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

  // Função para exibir o formulário de adição de Plataforma
  void _showAddDeveloperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Plataforma'),
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
                      return 'Por favor, insira o nome da Plataforma';
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
                  // Crie uma nova instância de Plataforma com os valores inseridos
                  Plataforma novaPlataforma = Plataforma(
                    nome: _nameController.text,
                    logoUrl: _logoUrlController.text,
                  );

                  // Adicione a nova Plataforma à coleção no Firestore
                  try {
                    await plataformasCollection.add({
                      'nome': novaPlataforma.nome,
                      'logoUrl': _logoUrlController.text,
                    });
                    print('Plataforma adicionada com sucesso.');
                  } catch (e) {
                    print('Erro ao adicionar a Plataforma: $e');
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
