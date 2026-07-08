import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matiere.dart';
import '../models/cours.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Matiere>> streamMatieres() {
    return _db
        .collection('matieres')
        .orderBy('nom')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Matiere.fromFirestore(doc)).toList());
  }

  Stream<List<Cours>> streamCoursParMatiere(String matiereId) {
    return _db
        .collection('cours')
        .where('matiereId', isEqualTo: matiereId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Cours.fromFirestore(doc)).toList());
  }

  Future<void> ajouterMatiere(Matiere matiere) {
    return _db.collection('matieres').add(matiere.toMap());
  }

  Future<void> modifierMatiere(Matiere matiere) {
    return _db
        .collection('matieres')
        .doc(matiere.id)
        .update(matiere.toMap());
  }

  Future<void> supprimerMatiere(String matiereId) {
    return _db.collection('matieres').doc(matiereId).delete();
  }

  Future<void> ajouterCours(Cours cours) {
    return _db.collection('cours').add(cours.toMap());
  }

  Future<void> modifierCours(Cours cours) {
    return _db.collection('cours').doc(cours.id).update(cours.toMap());
  }

  Future<void> supprimerCours(String coursId) {
    return _db.collection('cours').doc(coursId).delete();
  }
}