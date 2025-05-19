import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/providers/auth_state.dart';
import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/data/datasource/local/database_service.dart';
import 'package:dojo_challenge_app/data/datasource/remote/api_service.dart';
import 'package:dojo_challenge_app/data/datasource/remote/firestore_service.dart';
import 'package:dojo_challenge_app/data/repositories/movie_repository.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/screens/home_page.dart';
import 'package:dojo_challenge_app/presentation/screens/popular_movies.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthState;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  //This throws an UnimplementedError because it's being overriden in main.
  //It's handled this way to prevent all providers from being FutureProviders.
  throw UnimplementedError();
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiService(client: client);
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return MovieRepository(
    apiService: apiService,
    databaseService: databaseService,
    firestoreService: firestoreService,
  );
});

final moviesBlocProvider = Provider<MoviesBloc>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return MoviesBloc(movieRepository: movieRepository);
});

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState();
});

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MyHomePage(),
        routes: [
          GoRoute(
            path: 'sign-in',
            builder: (context, state) {
              return SignInScreen(
                actions: [
                  ForgotPasswordAction(((context, email) {
                    final uri = Uri(
                      path: '/sign-in/forgot-password',
                      queryParameters: <String, String?>{'email': email},
                    );
                    context.push(uri.toString());
                  })),
                  AuthStateChangeAction(((context, state) {
                    final user = switch (state) {
                      SignedIn state => state.user,
                      UserCreated state => state.credential.user,
                      _ => null,
                    };
                    if (user == null) {
                      return;
                    }
                    if (state is UserCreated) {
                      user.updateDisplayName(user.email!.split('@')[0]);
                    }
                    if (!user.emailVerified) {
                      user.sendEmailVerification();
                      const snackBar = SnackBar(
                        content: Text(
                          'Please check your email to verify your email address',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    context.pushReplacement('/');
                  })),
                ],
              );
            },
            routes: [
              GoRoute(
                path: 'forgot-password',
                builder: (context, state) {
                  final arguments = state.uri.queryParameters;
                  return ForgotPasswordScreen(
                    email: arguments['email'],
                    headerMaxExtent: 200,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) {
              return ProfileScreen(
                providers: const [],
                actions: [
                  SignedOutAction((context) {
                    context.pushReplacement('/');
                  }),
                ],
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/popular-movies',
        builder: (context, state) {
          final dataSource = state.extra as DataSource;
          return PopularMovies(dataSource: dataSource);
        },
      ),
    ],
  );
});
