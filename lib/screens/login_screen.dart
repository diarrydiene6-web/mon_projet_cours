import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/services_provider.dart';

const _kPrimary = Color(0xFF4C6EF5);
const _kPrimaryDark = Color(0xFF3B5BDB);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();

  bool _modeInscription = false;
  bool _chargement = false;
  String? _messageErreur;

  @override
  void dispose() {
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _chargement = true;
      _messageErreur = null;
    });

    final authService = ref.read(authServiceProvider);

    try {
      if (_modeInscription) {
        await authService.inscription(
          _emailController.text,
          _motDePasseController.text,
        );
      } else {
        await authService.connexion(
          _emailController.text,
          _motDePasseController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _messageErreur = authService.traduireErreur(e));
    } catch (e) {
      setState(() => _messageErreur = "Une erreur est survenue : $e");
    } finally {
      if (mounted) setState(() => _chargement = false);
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_kPrimary, Color(0xFFF5F6FA)],
            stops: [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.school_rounded,
                          size: 52, color: _kPrimary),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Matières & Cours',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                            _decoration('Email', Icons.email_outlined),
                            validator: (v) => (v == null || !v.contains('@'))
                                ? 'Email invalide'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _motDePasseController,
                            obscureText: true,
                            decoration: _decoration(
                                'Mot de passe', Icons.lock_outline_rounded),
                            validator: (v) => (v == null || v.length < 6)
                                ? '6 caractères minimum'
                                : null,
                          ),
                          if (_messageErreur != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _messageErreur!,
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [_kPrimary, _kPrimaryDark],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _kPrimary.withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _chargement ? null : _valider,
                                child: _chargement
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white),
                                )
                                    : Text(
                                  _modeInscription
                                      ? "S'inscrire"
                                      : 'Se connecter',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _chargement
                                ? null
                                : () => setState(
                                    () => _modeInscription = !_modeInscription),
                            child: Text(
                              _modeInscription
                                  ? 'Déjà un compte ? Se connecter'
                                  : "Pas de compte ? S'inscrire",
                              style: const TextStyle(color: _kPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}