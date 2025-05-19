import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movies App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Wanna see some popular movies?'),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                if (appState.loggedIn) {
                  context.push('/popular-movies', extra: DataSource.api);
                } else {
                  context.push('/sign-in');
                }
              },
              child: const Text('API'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                if (appState.loggedIn) {
                  context.push('/popular-movies', extra: DataSource.local);
                } else {
                  context.push('/sign-in');
                }
              },
              child: const Text('Local DB'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                if (appState.loggedIn) {
                  context.push('/popular-movies', extra: DataSource.firestore);
                } else {
                  context.push('/sign-in');
                }
              },
              child: const Text('Firestore'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                if (appState.loggedIn) {
                  FirebaseAuth.instance.signOut();
                } else {
                  context.push('/sign-in');
                }
              },
              child: Text(appState.loggedIn ? 'Logout' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
