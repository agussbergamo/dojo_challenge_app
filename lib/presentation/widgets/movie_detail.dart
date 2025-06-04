import 'dart:io';

import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movie_detail_bloc.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieDetail extends ConsumerStatefulWidget {
  const MovieDetail({
    super.key,
    required this.movie,
    required this.endpoint,
    this.dataSource,
  });

  final Movie movie;
  final Endpoint endpoint;
  final DataSource? dataSource;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
  late final MovieDetailBloc movieDetailBloc;
  final isTest = Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void initState() {
    super.initState();
    movieDetailBloc = ref.read(movieDetailBlocProvider);
    movieDetailBloc.initialize();
    movieDetailBloc.getRecommendedMovies(
      endpoint: widget.endpoint,
      movieId: widget.movie.id,
      dataSource: widget.dataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title ?? 'Movie',
          style: TextStyle(fontSize: 18),
        ),
        leading:
            context.canPop()
                ? IconButton(
                  onPressed: context.pop,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                )
                : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image(
                    image:
                        isTest
                            ? const AssetImage(
                              'assets/images/movie_placeholder.png',
                            )
                            : NetworkImage(widget.movie.fullBackdrop),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title ?? 'No title available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          side: BorderSide.none,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          'Play Trailer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    widget.movie.releaseDate != null &&
                            widget.movie.releaseDate!.length >= 4
                        ? widget.movie.releaseDate!.substring(0, 4)
                        : 'Unknown',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 6),
                  Text('|', style: TextStyle(color: Colors.grey[500])),
                  const SizedBox(width: 6),
                  Icon(Icons.star, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 6),
                  Text(
                    widget.movie.voteAverage != null
                        ? (widget.movie.voteAverage! / 2).toStringAsFixed(1)
                        : 'Not rated',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.movie.overview ?? 'No overview available',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Still in the mood? Try these!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            StreamBuilder<List<Movie>>(
              stream: movieDetailBloc.moviesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 180,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies found'));
                } else {}
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 120,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: Image(
                              image:
                                  isTest
                                      ? const AssetImage(
                                        'assets/images/movie_placeholder.png',
                                      )
                                      : NetworkImage(
                                        snapshot.data![index].fullPoster,
                                      ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
