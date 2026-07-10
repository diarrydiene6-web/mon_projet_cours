import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/matiere_provider.dart';
import '../providers/services_provider.dart';
import 'ajouter_matiere_screen.dart';
import 'cours_screen.dart';

// Palette de couleurs + icônes associées à chaque matière
class _MatiereStyle {
  final Color color;
  final IconData icon;
  const _MatiereStyle(this.color, this.icon);
}

_MatiereStyle _getStyle(String nom, int index) {
  final key = nom.toLowerCase();
  if (key.contains('angl')) return const _MatiereStyle(Color(0xFF4C6EF5), Icons.language);
  if (key.contains('franc') || key.contains('français')) return const _MatiereStyle(Color(0xFFEF476F), Icons.menu_book);
  if (key.contains('histoire') || key.contains('géo')) return const _MatiereStyle(Color(0xFFF77F00), Icons.public);
  if (key.contains('math')) return const _MatiereStyle(Color(0xFF06A77D), Icons.calculate);
  if (key.contains('svt') || key.contains('vivant')) return const _MatiereStyle(Color(0xFF9C36B5), Icons.eco);
  if (key.contains('physi') || key.contains('chimi')) return const _MatiereStyle(Color(0xFF198CF9), Icons.science);

  const palette = [
    _MatiereStyle(Color(0xFF4C6EF5), Icons.school),
    _MatiereStyle(Color(0xFFEF476F), Icons.book),
    _MatiereStyle(Color(0xFFF77F00), Icons.auto_stories),
    _MatiereStyle(Color(0xFF06A77D), Icons.edit_note),
  ];
  return palette[index % palette.length];
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matieresAsync = ref.watch(matieresProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Mes Matières', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4C6EF5),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
        backgroundColor: const Color(0xFF4C6EF5),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AjouterMatiereScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: matieresAsync.when(
        data: (matieres) {
          if (matieres.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune matière disponible pour le moment.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            itemCount: matieres.length,
            itemBuilder: (context, index) {
              final matiere = matieres[index];
              final style = _getStyle(matiere.nom, index);

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
                        color: style.color.withOpacity(0.15),
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
                          MaterialPageRoute(builder: (_) => CoursScreen(matiere: matiere)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: style.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(style.icon, color: style.color, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    matiere.nom,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    matiere.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit_outlined, color: style.color, size: 20),
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
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  tooltip: 'Supprimer',
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text('Confirmer la suppression'),
                                        content: Text('Voulez-vous vraiment supprimer "${matiere.nom}" ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ref.read(matiereNotifierProvider.notifier).supprimerMatiere(matiere.id);
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