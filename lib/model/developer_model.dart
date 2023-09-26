import 'package:cloud_firestore/cloud_firestore.dart';

class Developer {
  final String id;
  final String name;
  final String logoUrl;

  Developer({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  // cria uma instância de Developer
  factory Developer.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Developer(
      id: doc.id,
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'] ?? '', 
    );
  }

}