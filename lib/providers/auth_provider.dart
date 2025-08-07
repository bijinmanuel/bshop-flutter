import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  /// Called automatically when auth state changes (login, logout)
  void _onAuthStateChanged(User? firebaseUser) {
    _user = firebaseUser;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// Sign up with email & password
  Future<bool> signUp(String email, String password) async {
    try {
      setLoading(true);
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = _auth.currentUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('SignUp Error: $e');
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  /// Sign in with email & password
  Future<bool> signIn(String email, String password) async {
    try {
      setLoading(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('SignIn Error: $e');
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    try {
      setLoading(true);
      await _auth.signOut();
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('SignOut Error: $e');
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
