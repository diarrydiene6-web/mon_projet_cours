import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/matiere_provider.dart';

class FormulaireMatiereScreen extends ConsumerStatefulWidget {
  final String? matiereId;
  final String? nomInitial;
  final String? descriptionInitiale;

  const FormulaireMatiereScreen({
    super.key,
    this.matiereId,
    this.nomInitial,
    this.descriptionInitiale,
  });

  @override
  ConsumerState<FormulaireMatiereScreen> createState() =>
      _FormulaireMatiereScreenState();
}

class _FormulaireMatiereScreenState extends ConsumerState<FormulaireMatiereScreen> {
  late TextEditingController nomController;
  late TextEditingController descController;

  bool get isModification => widget.matiereId != null;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.nomInitial ?? '');
    descController = TextEditingController(text: widget.descriptionInitiale ?? '');
  }

  @override
  void dispose() {
    nomController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> enregistrer() async {
    final nom = nomController.text.trim();
    final description = descController.text.trim();

    if (nom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom est obligatoire')),
      );
      return;
    }

    final notifier = ref.read(matiereNotifierProvider.notifier);

    if (isModification) {
      await notifier.modifierMatiere(widget.matiereId!, nom, description);
    } else {
      await notifier.ajouterMatiere(nom, description);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(isModification ? 'Modifier la matière' : 'Nouvelle matière'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: enregistrer,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}