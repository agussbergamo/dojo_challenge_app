import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dojo_challenge_app/core/auth/auth_state.dart';
import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/data/datasources/local/database_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/remote/api_data_source.dart';
import 'package:dojo_challenge_app/data/datasources/remote/firestore_data_source.dart';
import 'package:dojo_challenge_app/data/repositories/movies_repository.dart';
import 'package:dojo_challenge_app/domain/usecases/implementations/movies_usecase.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/screens/home_page.dart';
import 'package:dojo_challenge_app/presentation/screens/popular_movies.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide AuthState;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final databaseDataSourceProvider = Provider<DatabaseDataSource>((ref) {
  //This throws an UnimplementedError because it's being overriden in main.
  //It's handled this way to prevent all providers from being FutureProviders.
  throw UnimplementedError();
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final apiDataSourceProvider = Provider<ApiDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiDataSource(client: client);
});

final firestoreDataSourceProvider = Provider<FirestoreDataSource>((ref) {
  return FirestoreDataSource(FirebaseFirestore.instance);
});

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final apiDataSource = ref.watch(apiDataSourceProvider);
  final databaseDataSource = ref.watch(databaseDataSourceProvider);
  final firestoreDataSource = ref.watch(firestoreDataSourceProvider);
  return MoviesRepository(
    apiDataSource: apiDataSource,
    databaseDataSource: databaseDataSource,
    firestoreDataSource: firestoreDataSource,
  );
});

final moviesUseCaseProvider = Provider<MoviesUseCase>((ref) {
  final moviesRepository = ref.watch(moviesRepositoryProvider);
  return MoviesUseCase(moviesRepository: moviesRepository);
});

final moviesBlocProvider = Provider<MoviesBloc>((ref) {
  final moviesUseCase = ref.watch(moviesUseCaseProvider);
  return MoviesBloc(moviesUsecase: moviesUseCase);
});

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  final authState = AuthState();
  authState.init();
  return authState;
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
