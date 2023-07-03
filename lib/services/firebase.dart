import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAutenticacao {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static void inicializa() async {
    await Firebase.initializeApp();
  }

  static Future<bool> login(String usuario, String senha) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: usuario, password: senha);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
