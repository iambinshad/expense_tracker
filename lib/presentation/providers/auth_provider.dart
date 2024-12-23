import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isSignIn = true;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isSignIn => _isSignIn;
  String? get error => _error;

  void toggleMode() {
    _isSignIn = !_isSignIn;
    notifyListeners();
  }

  Future<void> signInOrSignUp(String email, String password, [String? name]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_isSignIn) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (name != null) {
          await userCredential.user?.updateDisplayName(name);
        }
      }
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
