import 'package:cloud_firestore/cloud_firestore.dart';

enum NiveauCours {
  debutant,
  intermediaire,
  avance,
}

extension NiveauCoursLabel on NiveauCours {
  String get label {
    switch (this) {
      case NiveauCours.debutant:
        return 'Débutant';
      case NiveauCours.intermediaire:
        return 'Intermédiaire';
      case NiveauCours.avance:
        return 'Avancé';
    }
  }
}

/// Représente un cours proposé au sein d'une matière.
class Cours {
  final String id;
  final String matiereId;
  final String titre;
  final String description;
  final String professeur;
  final int dureeHeures;
  final NiveauCours niveau;
  final DateTime createdAt;

  Cours({
    required this.id,
    required this.matiereId,
    required this.titre,
    required this.description,
    required this.professeur,
    required this.dureeHeures,
    required this.niveau,
    required this.createdAt,
  });

  factory Cours.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Cours(
      id: doc.id,
      matiereId: data['matiereId'] ?? '',
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      professeur: data['professeur'] ?? '',
      dureeHeures: data['dureeHeures'] ?? 0,
      niveau: NiveauCours.values.firstWhere(
            (n) => n.name == data['niveau'],
        orElse: () => NiveauCours.debutant,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'matiereId': matiereId,
      'titre': titre,
      'description': description,
      'professeur': professeur,
      'dureeHeures': dureeHeures,
      'niveau': niveau.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}