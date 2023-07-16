import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DBFirestore {
  //static final DBFirestore _instance = DBFirestore._();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String _tbUser = '';
  static String _tbPass = '';
  static String _bwUser = '';
  static String _bwPass = '';

  DBFirestore._();

  static void getData() async {
    QuerySnapshot query = await _firestore.collection('thingsboard').get();
    for (var element in query.docs) {
      _tbUser = element.get('login');
      _tbPass = element.get('pass');
    }

    query = await _firestore.collection('beweather').get();
    for (var element in query.docs) {
      _bwUser = element.get('login');
      _bwPass = element.get('pass');
    }
  }

  static String getTBUser() {
    return _tbUser;
  }

  String getTBPass() {
    return _tbPass;
  }

  static String getBWUser() {
    return _bwUser;
  }

  String getBWPass() {
    return _bwPass;
  }
}

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
