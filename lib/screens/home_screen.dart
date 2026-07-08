import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/matiere_provider.dart';
import '../providers/services_provider.dart';
import 'ajouter_matiere_screen.dart';
import 'cours_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matieresAsync = ref.watch(matieresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matières'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Se déconnecter',
            onPressed: () {
              ref.read(authServiceProvider).deconnexion();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AjouterMatiereScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: matieresAsync.when(
        data: (matieres) {
          if (matieres.isEmpty) {
            return const Center(
              child: Text(
                'Aucune matière disponible pour le moment.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: matieres.length,
            itemBuilder: (context, index) {
              final matiere = matieres[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.menu_book_rounded),
                  ),
                  title: Text(
                    matiere.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    matiere.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Modifier',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AjouterMatiereScreen(
                                matiereId: matiere.id,
                                nomInitial: matiere.nom,
                                descriptionInitiale: matiere.description,
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
                                  'Voulez-vous vraiment supprimer "${matiere.nom}" ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(matiereNotifierProvider.notifier)
                                        .supprimerMatiere(matiere.id);
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
                        builder: (_) => CoursScreen(matiere: matiere),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (erreur, stack) => Center(
          child: Text('Erreur : $erreur'),
        ),
      ),
    );
  }
}