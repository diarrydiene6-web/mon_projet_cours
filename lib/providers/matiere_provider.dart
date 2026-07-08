import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/matiere_repository.dart';
import '../models/matiere.dart';
// Provider du repository
final matiereRepositoryProvider = Provider<MatiereRepository>((ref) {
  return MatiereRepository();
});

// Provider qui écoute la liste des matières en temps réel (QuerySnapshot brut)
final matieresStreamProvider = StreamProvider<QuerySnapshot>((ref) {
  final repository = ref.watch(matiereRepositoryProvider);
  return repository.getMatieres();
});

// Provider utilisé par home_screen.dart : retourne directement List<Matiere>
final matieresProvider = StreamProvider<List<Matiere>>((ref) {
  final repository = ref.watch(matiereRepositoryProvider);
  return repository.getMatieres().map((snapshot) {
    return snapshot.docs.map((doc) => Matiere.fromFirestore(doc)).toList();
  });
});

// Notifier pour gérer ajout/modification/suppression
class MatiereNotifier extends StateNotifier<AsyncValue<void>> {
  final MatiereRepository _repository;

  MatiereNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> ajouterMatiere(String nom, String description) async {
    state = const AsyncValue.loading();
    try {
      await _repository.ajouterMatiere(nom, description);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> modifierMatiere(String id, String nom, String description) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateMatiere(id, nom, description);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> supprimerMatiere(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteMatiere(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final matiereNotifierProvider =
StateNotifierProvider<MatiereNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(matiereRepositoryProvider);
  return MatiereNotifier(repository);
});