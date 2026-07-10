import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/matiere.dart';
import '../models/cours.dart';
import '../providers/cours_provider.dart';
import '../providers/services_provider.dart';
import 'ajouter_cours_screen.dart';
import 'cours_detail_screen.dart';

// Couleur associée à chaque niveau
Color _couleurNiveau(String label) {
  final key = label.toLowerCase();
  if (key.contains('débutant') || key.contains('debutant')) return const Color(0xFF06A77D);
  if (key.contains('intermédiaire') || key.contains('intermediaire')) return const Color(0xFFF77F00);
  if (key.contains('avancé') || key.contains('avance')) return const Color(0xFFEF476F);
  return const Color(0xFF4C6EF5);
}

class CoursScreen extends ConsumerWidget {
  final Matiere matiere;

  const CoursScreen({super.key, required this.matiere});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursAsync = ref.watch(coursParMatiereProvider(matiere.id));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text('Cours - ${matiere.nom}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4C6EF5),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4C6EF5),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AjouterCoursScreen(matiere: matiere),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: coursAsync.when(
        data: (cours) {
          if (cours.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun cours disponible pour cette matière.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            itemCount: cours.length,
            itemBuilder: (context, index) {
              final c = cours[index];
              final couleur = _couleurNiveau(c.niveau.label);

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + index * 60),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: child,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: couleur.withOpacity(0.15),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CoursDetailScreen(cours: c)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.titre,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: couleur.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    c.niveau.label,
                                    style: TextStyle(
                                      color: couleur,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.person_outline, size: 16, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  c.professeur,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  '${c.dureeHeures}h',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(Icons.edit_outlined, color: couleur, size: 20),
                                  tooltip: 'Modifier',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
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
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  tooltip: 'Supprimer',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text('Confirmer la suppression'),
                                        content: Text('Voulez-vous vraiment supprimer "${c.titre}" ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ref.read(firestoreServiceProvider).supprimerCours(c.id);
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
                          ],
                        ),
                      ),
                    ),
                  ),
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