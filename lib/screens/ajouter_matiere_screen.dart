import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/matiere.dart';
import '../providers/services_provider.dart';

const _kPrimary = Color(0xFF4C6EF5);

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
        await firestoreService.modifierMatiere(Matiere(
          id: widget.matiereId!,
          nom: _nomController.text.trim(),
          description: _descController.text.trim(),
          createdAt: DateTime.now(),
        ));
      } else {
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
          isModification ? 'Modifier la matière' : 'Nouvelle matière',
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
                controller: _nomController,
                decoration: _decoration('Nom', Icons.menu_book_outlined),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descController,
                decoration: _decoration('Description', Icons.notes),
                maxLines: 3,
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