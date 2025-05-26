import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final void Function(List<AuthProvider>) _configureProviders;

  AuthState({
    FirebaseAuth? firebaseAuth,
    void Function(List<AuthProvider>)? configureProviders,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _configureProviders =
           configureProviders ??
           ((List<AuthProvider> providers) {
             FirebaseUIAuth.configureProviders(providers);
           });

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> init() async {
    _configureProviders([EmailAuthProvider()]);

    _firebaseAuth.userChanges().listen((user) {
      _loggedIn = user != null;
      notifyListeners();
    });
  }
}
