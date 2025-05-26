import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/presentation/widgets/data_source_card.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.movie_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Flutter & Furious',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      authState.loggedIn
                          ? 'Great to see you around, ${user?.displayName ?? 'user'}!'
                          : 'You need to be logged in to see our awesome content!',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (authState.loggedIn) {
                      FirebaseAuth.instance.signOut();
                    } else {
                      context.push('/sign-in');
                    }
                  },
                  icon: Icon(
                    authState.loggedIn ? Icons.logout : Icons.login,
                    size: 16,
                  ),
                  label: Text(authState.loggedIn ? 'Logout' : 'Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to the tiniest Movies App!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Looking for the hottest movies right now? You've come to the right place!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please let us know where do you want us to get your movies from:',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  DataSourceCard(
                    icon: Icons.cloud,
                    label: 'API',
                    source: DataSource.api,
                    loggedIn: authState.loggedIn,
                  ),
                  const SizedBox(height: 12),
                  DataSourceCard(
                    icon: Icons.storage,
                    label: 'Local DB',
                    source: DataSource.local,
                    loggedIn: authState.loggedIn,
                  ),
                  const SizedBox(height: 12),
                  DataSourceCard(
                    icon: Icons.cloud_upload,
                    label: 'Firestore',
                    source: DataSource.firestore,
                    loggedIn: authState.loggedIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
