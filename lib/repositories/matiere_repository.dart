import 'package:cloud_firestore/cloud_firestore.dart';

class MatiereRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // LIRE toutes les matières
  Stream<QuerySnapshot> getMatieres() {
    return _firestore.collection('matieres').orderBy('nom').snapshots();
  }

  // AJOUTER une matière
  Future<void> ajouterMatiere(String nom, String description) async {
    await _firestore.collection('matieres').add({
      'nom': nom,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // MODIFIER une matière
  Future<void> updateMatiere(String matiereId, String nom, String description) async {
    await _firestore.collection('matieres').doc(matiereId).update({
      'nom': nom,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // SUPPRIMER une matière
  Future<void> deleteMatiere(String matiereId) async {
    await _firestore.collection('matieres').doc(matiereId).delete();
  }
}