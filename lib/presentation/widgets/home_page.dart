import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
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
    final user = authState.currentUser;
    final selectedEndpoint = ref.watch(selectedEndpointProvider);
    final selectedDataSource = ref.watch(selectedDataSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.movie_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text('Flutter & Furious', style: TextStyle(fontSize: 18)),
          ],
        ),
        centerTitle: true,
        leading:
            context.canPop()
                ? IconButton(
                  onPressed: context.pop,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                )
                : null,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                          vertical: 6,
                        ),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 100,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                authState.loggedIn
                                    ? [
                                      Text(
                                        "Looking for the hottest movies right now, ${user?.displayName}?",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "You've come to the right place!\nJust pick two quick options and let the magic happen.",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Which movie bunch speaks to your soul?',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      DropdownButtonFormField<Endpoint>(
                                        key: const Key('endpointDropdown'),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.0,
                                        ),
                                        value: selectedEndpoint,
                                        onChanged: (value) {
                                          if (value != null) {
                                            ref
                                                .read(
                                                  selectedEndpointProvider
                                                      .notifier,
                                                )
                                                .state = value;
                                          }
                                        },
                                        items:
                                            [
                                              Endpoint.popular,
                                              Endpoint.topRated,
                                            ].map((type) {
                                              return DropdownMenuItem(
                                                value: type,
                                                child: Text(type.value),
                                              );
                                            }).toList(),
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Let us show off a bit. We've got your movies stored in 3 different places, turn on your dev mode and pick your favorite!",
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 30),
                                      DropdownButtonFormField<DataSource>(
                                        key: const Key('dataSourceDropdown'),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.0,
                                        ),
                                        value: selectedDataSource,
                                        onChanged: (value) {
                                          if (value != null) {
                                            ref
                                                .read(
                                                  selectedDataSourceProvider
                                                      .notifier,
                                                )
                                                .state = value;
                                          }
                                        },
                                        items:
                                            [
                                              DataSource.api,
                                              DataSource.local,
                                              DataSource.firestore,
                                            ].map((source) {
                                              return DropdownMenuItem(
                                                value: source,
                                                child: Text(source.value),
                                              );
                                            }).toList(),
                                      ),
                                      const SizedBox(height: 30),
                                      OutlinedButton(
                                        onPressed: () {
                                          if (authState.loggedIn) {
                                            context.push(
                                              '/movies',
                                              extra: {
                                                'endpoint': selectedEndpoint,
                                                'dataSource':
                                                    selectedDataSource,
                                              },
                                            );
                                          } else {
                                            context.push('/sign-in');
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.limeAccent,
                                          side: BorderSide(
                                            color: Colors.limeAccent,
                                          ),
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: const Text('Take me there!'),
                                      ),
                                    ]
                                    : [
                                      Text(
                                        "We tried… but nope, still don't know who you are!",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Please log in to see all the awesome stuff we've got waiting!",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
