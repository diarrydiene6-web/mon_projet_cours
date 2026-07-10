import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cours.dart';
import '../models/matiere.dart';
import '../providers/services_provider.dart';

const _kPrimary = Color(0xFF4C6EF5);

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

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _kPrimary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _kPrimary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          isModification
              ? 'Modifier le cours'
              : 'Nouveau cours - ${widget.matiere.nom}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: _decoration('Titre', Icons.title),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descController,
                decoration: _decoration('Description', Icons.notes),
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _professeurController,
                decoration: _decoration('Professeur', Icons.person_outline),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _dureeController,
                decoration: _decoration('Durée (heures)', Icons.access_time),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<NiveauCours>(
                initialValue: _niveau,
                decoration: _decoration('Niveau', Icons.bar_chart),
                items: NiveauCours.values
                    .map((n) =>
                    DropdownMenuItem(value: n, child: Text(n.label)))
                    .toList(),
                onChanged: (v) => setState(() => _niveau = v!),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _enregistrement ? null : _enregistrer,
                  child: _enregistrement
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Enregistrer',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}