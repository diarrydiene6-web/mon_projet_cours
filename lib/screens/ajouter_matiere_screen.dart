import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/matiere.dart';
import '../providers/services_provider.dart';

class AjouterMatiereScreen extends ConsumerStatefulWidget {
  final String? matiereId;
  final String? nomInitial;
  final String? descriptionInitiale;

  const AjouterMatiereScreen({
    super.key,
    this.matiereId,
    this.nomInitial,
    this.descriptionInitiale,
  });

  @override
  ConsumerState<AjouterMatiereScreen> createState() =>
      _AjouterMatiereScreenState();
}

class _AjouterMatiereScreenState extends ConsumerState<AjouterMatiereScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _descController;
  bool _enregistrement = false;

  bool get isModification => widget.matiereId != null;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.nomInitial ?? '');
    _descController =
        TextEditingController(text: widget.descriptionInitiale ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enregistrement = true);
    try {
      final firestoreService = ref.read(firestoreServiceProvider);

      if (isModification) {
        // MODIFICATION
        await firestoreService.modifierMatiere(Matiere(
          id: widget.matiereId!,
          nom: _nomController.text.trim(),
          description: _descController.text.trim(),
          createdAt: DateTime.now(),
        ));
      } else {
        // AJOUT
        await firestoreService.ajouterMatiere(Matiere(
          id: '',
          nom: _nomController.text.trim(),
          description: _descController.text.trim(),
          createdAt: DateTime.now(),
        ));
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) setState(() => _enregistrement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isModification ? 'Modifier la matière' : 'Nouvelle matière'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enregistrement ? null : _enregistrer,
                child: _enregistrement
                    ? const CircularProgressIndicator()
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}