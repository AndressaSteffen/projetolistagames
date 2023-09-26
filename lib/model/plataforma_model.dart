import 'package:cloud_firestore/cloud_firestore.dart';

class Plataforma {
  final String id;
  final String name;
  final String logoUrl;

  Plataforma({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  // Cria uma instância de Plataforma
  factory Plataforma.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Plataforma(
      id: doc.id,
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '', 
    );
  }   
}
