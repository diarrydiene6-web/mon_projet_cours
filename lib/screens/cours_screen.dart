import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/matiere.dart';
import '../models/cours.dart';
import '../providers/cours_provider.dart';
import '../providers/services_provider.dart';
import 'ajouter_cours_screen.dart';
import 'cours_detail_screen.dart';

class CoursScreen extends ConsumerWidget {
  final Matiere matiere;

  const CoursScreen({super.key, required this.matiere});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursAsync = ref.watch(coursParMatiereProvider(matiere.id));

    return Scaffold(
      appBar: AppBar(title: Text('Cours - ${matiere.nom}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AjouterCoursScreen(matiere: matiere),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: coursAsync.when(
        data: (cours) {
          if (cours.isEmpty) {
            return const Center(
              child: Text(
                'Aucun cours disponible pour cette matière.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cours.length,
            itemBuilder: (context, index) {
              final c = cours[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(c.titre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    c.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(label: Text(c.niveau.label)),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Modifier',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AjouterCoursScreen(
                                matiere: matiere,
                                coursExistant: c,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Supprimer',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: Text(
                                  'Voulez-vous vraiment supprimer "${c.titre}" ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(firestoreServiceProvider)
                                        .supprimerCours(c.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Supprimer',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CoursDetailScreen(cours: c),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (erreur, stack) => Center(child: Text('Erreur : $erreur')),
      ),
    );
  }
}