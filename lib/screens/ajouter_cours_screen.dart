import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cours.dart';
import '../models/matiere.dart';
import '../providers/services_provider.dart';

class AjouterCoursScreen extends ConsumerStatefulWidget {
  final Matiere matiere;
  final Cours? coursExistant;

  const AjouterCoursScreen({
    super.key,
    required this.matiere,
    this.coursExistant,
  });

  @override
  ConsumerState<AjouterCoursScreen> createState() =>
      _AjouterCoursScreenState();
}

class _AjouterCoursScreenState extends ConsumerState<AjouterCoursScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titreController;
  late final TextEditingController _descController;
  late final TextEditingController _professeurController;
  late final TextEditingController _dureeController;
  late NiveauCours _niveau;
  bool _enregistrement = false;

  bool get isModification => widget.coursExistant != null;

  @override
  void initState() {
    super.initState();
    final c = widget.coursExistant;
    _titreController = TextEditingController(text: c?.titre ?? '');
    _descController = TextEditingController(text: c?.description ?? '');
    _professeurController = TextEditingController(text: c?.professeur ?? '');
    _dureeController =
        TextEditingController(text: c != null ? '${c.dureeHeures}' : '1');
    _niveau = c?.niveau ?? NiveauCours.debutant;
  }

  @override
  void dispose() {
    _titreController.dispose();
    _descController.dispose();
    _professeurController.dispose();
    _dureeController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enregistrement = true);
    try {
      final firestoreService = ref.read(firestoreServiceProvider);

      if (isModification) {
        // MODIFICATION
        await firestoreService.modifierCours(Cours(
          id: widget.coursExistant!.id,
          matiereId: widget.matiere.id,
          titre: _titreController.text.trim(),
          description: _descController.text.trim(),
          professeur: _professeurController.text.trim(),
          dureeHeures: int.tryParse(_dureeController.text) ?? 0,
          niveau: _niveau,
          createdAt: widget.coursExistant!.createdAt,
        ));
      } else {
        // AJOUT
        await firestoreService.ajouterCours(Cours(
          id: '',
          matiereId: widget.matiere.id,
          titre: _titreController.text.trim(),
          description: _descController.text.trim(),
          professeur: _professeurController.text.trim(),
          dureeHeures: int.tryParse(_dureeController.text) ?? 0,
          niveau: _niveau,
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
        title: Text(isModification
            ? 'Modifier le cours'
            : 'Nouveau cours - ${widget.matiere.nom}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _professeurController,
                decoration: const InputDecoration(labelText: 'Professeur'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dureeController,
                decoration:
                const InputDecoration(labelText: 'Durée (heures)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<NiveauCours>(
                initialValue: _niveau,
                decoration: const InputDecoration(labelText: 'Niveau'),
                items: NiveauCours.values
                    .map((n) =>
                    DropdownMenuItem(value: n, child: Text(n.label)))
                    .toList(),
                onChanged: (v) => setState(() => _niveau = v!),
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