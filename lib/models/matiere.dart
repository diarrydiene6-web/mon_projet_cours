import 'package:cloud_firestore/cloud_firestore.dart';

class Matiere {
  final String id;
  final String nom;
  final String description;
  final DateTime createdAt;

  Matiere({
    required this.id,
    required this.nom,
    required this.description,
    required this.createdAt,
  });

  factory Matiere.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Matiere(
      id: doc.id,
      nom: data['nom'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}