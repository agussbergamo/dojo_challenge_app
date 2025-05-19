import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularMovies extends ConsumerStatefulWidget {
  final DataSource? dataSource;
  const PopularMovies({super.key, this.dataSource});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PopularMoviesState();
}

class _PopularMoviesState extends ConsumerState<PopularMovies> {
  late final MoviesBloc moviesBloc;

  @override
  void initState() {
    super.initState();
    moviesBloc = ref.read(moviesBlocProvider);
    moviesBloc.initialize();
    moviesBloc.getPopularMovies(widget.dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Popular Movies')),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(snapshot.data![index].title));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
