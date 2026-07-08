import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/matiere_provider.dart';
import 'formulaire_matiere_screen.dart';

class MatiereListScreen extends ConsumerWidget {
  const MatiereListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matieresAsync = ref.watch(matieresStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Matières')),
      body: matieresAsync.when(
        data: (snapshot) {
          final docs = snapshot.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Aucune matière pour le moment'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final nom = data['nom'] ?? '';
              final description = data['description'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormulaireMatiereScreen(
                                matiereId: doc.id,
                                nomInitial: nom,
                                descriptionInitiale: description,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: Text('Voulez-vous vraiment supprimer "$nom" ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(matiereNotifierProvider.notifier)
                                        .supprimerMatiere(doc.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Erreur : $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormulaireMatiereScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}