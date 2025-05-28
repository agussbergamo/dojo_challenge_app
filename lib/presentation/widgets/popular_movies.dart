import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/widgets/movie_card.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularMovies extends ConsumerStatefulWidget {
  final DataSource? dataSource;
  const PopularMovies({super.key, this.dataSource});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PopularMoviesState();
}

class _PopularMoviesState extends ConsumerState<PopularMovies>
    with SingleTickerProviderStateMixin {
  late final MoviesBloc moviesBloc;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    moviesBloc = ref.read(moviesBlocProvider);
    moviesBloc.initialize();
    moviesBloc.getPopularMovies(dataSource: widget.dataSource);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Popular Movies', style: TextStyle(fontSize: 18)),
        ),
        body: StreamBuilder<List<Movie>>(
          stream: moviesBloc.moviesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No movies found'));
            } else {
              if (!_animationController.isAnimating &&
                  _animationController.status == AnimationStatus.dismissed) {
                _animationController.forward();
              }
              return AnimatedBuilder(
                animation: _animationController,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      imageUrl: snapshot.data![index].fullPoster,
                      overview: snapshot.data![index].overview,
                      title: snapshot.data![index].title,
                      voteAverage: snapshot.data![index].voteAverage / 2,
                    );
                  },
                ),
                builder:
                    (context, child) => SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 1.2),
                        end: const Offset(0, 0),
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: child,
                    ),
              );
            }
          },
        ),
      ),
    );
  }
}
