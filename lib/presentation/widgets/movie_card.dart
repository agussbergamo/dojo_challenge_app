import 'dart:io';

import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieCard extends ConsumerWidget {
  MovieCard({
    super.key,
    required this.movie,
    required this.endpoint,
    this.dataSource,
  });

  final Movie movie;
  final Endpoint endpoint;
  final DataSource? dataSource;
  final isTest = Platform.environment.containsKey('FLUTTER_TEST');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = constraints.maxWidth / 2;
        final imageAspectRatio = 2 / 3;

        return SizedBox(
          width: constraints.maxWidth,
          height: halfWidth / imageAspectRatio,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: halfWidth - 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image(
                      image:
                          isTest
                              ? const AssetImage(
                                'assets/images/movie_placeholder.png',
                              )
                              : NetworkImage(movie.fullPoster),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: halfWidth - 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title ?? 'No title available',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              movie.voteAverage != null
                                  ? (movie.voteAverage! / 2).toStringAsFixed(1)
                                  : 'Not rated',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            RatingBarIndicator(
                              rating: (movie.voteAverage ?? 0.0) / 2,
                              itemBuilder:
                                  (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                              itemCount: 5,
                              itemSize: 24.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            movie.overview ?? 'No overview available',
                            maxLines: 10,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () {
                              if (authState.loggedIn) {
                                context.push(
                                  '/movie-detail',
                                  extra: {
                                    'movie': movie,
                                    'endpoint': Endpoint.recommendations,
                                    'dataSource': dataSource,
                                  },
                                );
                              } else {
                                context.push('/sign-in');
                              }
                            },
                            icon: const Icon(Icons.add, color: Colors.white70),
                            label: const Text(
                              'More info',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
