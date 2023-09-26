import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listagames/view/desenvolvedoras.dart';
import 'package:listagames/view/plataformas.dart';
import 'package:listagames/view/jogos.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Listinha de Jogos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Navegue para a página correspondente com base na opção selecionada.
              if (value == 'Jogos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JogosPage()),
                );
              } else if (value == 'Plataformas') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlataformasPage()),
                );
              } else if (value == 'Desenvolvedoras') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DesenvolvedorasPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Jogos',
                child: Text('Jogos'),
              ),
              PopupMenuItem<String>(
                value: 'Plataformas',
                child: Text('Plataformas'),
              ),
              PopupMenuItem<String>(
                value: 'Desenvolvedoras',
                child: Text('Desenvolvedoras'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jogos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Se chegamos aqui, os dados foram carregados com sucesso do Firestore
          List<QueryDocumentSnapshot> jogos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jogos.length,
            itemBuilder: (context, index) {
              final jogo = jogos[index].data() as Map<String, dynamic>;

              // Verifique os valores booleanos e defina as cores dos botões
              Color jogandoColor = jogo['jogando'] ? Colors.green : Colors.red;
              Color terminadoColor = jogo['terminado'] ? Colors.green : Colors.red;

              return Card(
                child: ListTile(
                  leading: Container(
                    width: 120, // Defina a largura do widget leading
                    child: Image.network(jogo['logoUrl']),
                  ),
                  title: Text(jogo['nome']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica para alternar o estado "Jogando"
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: jogandoColor),
                          child: Text('Jogando'),
                        ),
                      ),
                      SizedBox(
                        width: 10, // Espaço entre os botões
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica para alternar o estado "Terminado"
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: terminadoColor),
                          child: Text('Terminado'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
