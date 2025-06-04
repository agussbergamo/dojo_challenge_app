import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/core/parameter/endpoint.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/presentation/widgets/movie_card.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MoviesList extends ConsumerStatefulWidget {
  final Endpoint endpoint;
  final DataSource? dataSource;
  const MoviesList({super.key, required this.endpoint, this.dataSource});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoviesListState();
}

class _MoviesListState extends ConsumerState<MoviesList>
    with SingleTickerProviderStateMixin {
  late final MoviesBloc moviesBloc;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    moviesBloc = ref.read(moviesBlocProvider);
    moviesBloc.initialize();
    moviesBloc.getMovies(
      endpoint: widget.endpoint,
      dataSource: widget.dataSource,
    );
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
          title: Text(
            '${widget.endpoint.value} Movies',
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
                      movie: snapshot.data![index],
                      endpoint: widget.endpoint,
                      dataSource: widget.dataSource,
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
