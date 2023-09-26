import 'package:cloud_firestore/cloud_firestore.dart';

class Desenvolvedora {
  final String id;
  final String name;
  final String logoUrl;

  Desenvolvedora({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  // cria uma instância de Desenvolvedora
  factory Desenvolvedora.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Desenvolvedora(
      id: doc.id,
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '', 
    );
  }

}