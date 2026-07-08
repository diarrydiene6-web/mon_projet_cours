import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get utilisateurCourant => _auth.authStateChanges();

  User? get utilisateurActuel => _auth.currentUser;

  Future<User?> connexion(String email, String motDePasse) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: motDePasse,
    );
    return credential.user;
  }

  Future<User?> inscription(String email, String motDePasse) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: motDePasse,
    );
    return credential.user;
  }

  Future<void> deconnexion() async {
    await _auth.signOut();
  }

  String traduireErreur(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "Aucun compte ne correspond à cet email.";
      case 'wrong-password':
        return "Mot de passe incorrect.";
      case 'invalid-email':
        return "L'adresse email n'est pas valide.";
      case 'email-already-in-use':
        return "Un compte existe déjà avec cet email.";
      case 'weak-password':
        return "Le mot de passe est trop faible (6 caractères minimum).";
      case 'invalid-credential':
        return "Email ou mot de passe incorrect.";
      default:
        return "Erreur : ${e.message ?? e.code}";
    }
  }
}