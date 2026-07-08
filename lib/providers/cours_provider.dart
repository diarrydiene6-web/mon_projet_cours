import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cours.dart';
import 'services_provider.dart';

final coursParMatiereProvider =
StreamProvider.family<List<Cours>, String>((ref, matiereId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamCoursParMatiere(matiereId);
});