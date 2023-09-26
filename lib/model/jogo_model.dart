import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listagames/model/desenvolvedora_model.dart';
import 'package:listagames/model/plataforma_model.dart';


class Jogo {
  final String id;
  final String nome;
  final String logoUrl;
  final double totalHoras;
  final double preco;
  final String desenvolvedoraId;
  final String plataformaId;
  final bool jogando;
  final bool terminado;

  Jogo({
    required this.id,
    required this.nome,
    required this.logoUrl,
    required this.totalHoras,
    required this.preco,
    required this.desenvolvedoraId,
    required this.plataformaId,
    required this.jogando,
    required this.terminado,
  });

  factory Jogo.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
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
  }

}