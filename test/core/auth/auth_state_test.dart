import 'package:dojo_challenge_app/core/auth/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'auth_state_test.mocks.dart';

// This class can't be 100% covered without initializing real FirebaseApp

@GenerateMocks([FirebaseAuth, User])
void main() {
  late MockFirebaseAuth mockAuth;
  late StreamController<User?> userStreamController;
  late bool providersConfigured;
  late User mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    userStreamController = StreamController<User?>();
    providersConfigured = false;
  });

  tearDown(() {
    userStreamController.close();
  });

  test('should update loggedIn to true when user is present', () async {
    when(mockAuth.userChanges()).thenAnswer((_) => userStreamController.stream);

    final authState = AuthState(
      firebaseAuth: mockAuth,
      configureProviders: (_) {
        providersConfigured = true;
      },
    );

    await authState.init();

    expect(authState.loggedIn, false);

    final mockUser = MockUser();
    userStreamController.add(mockUser);

    await Future.delayed(Duration(milliseconds: 10));

    expect(authState.loggedIn, true);
    expect(providersConfigured, true);
  });

  test('should update loggedIn to false when user is null', () async {
    when(mockAuth.userChanges()).thenAnswer((_) => userStreamController.stream);

    final authState = AuthState(
      firebaseAuth: mockAuth,
      configureProviders: (_) {},
    );

    await authState.init();

    userStreamController.add(null);

    await Future.delayed(Duration(milliseconds: 10));

    expect(authState.loggedIn, false);
  });

  test('should return currentUser correctly', () {
    when(mockAuth.currentUser).thenReturn(mockUser);

    final authState = AuthState(firebaseAuth: mockAuth);

    expect(authState.currentUser, mockUser);
  });
}
