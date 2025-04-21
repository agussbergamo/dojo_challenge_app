import 'package:dojo_challenge_app/domain/entities/movie.dart';
import 'package:dojo_challenge_app/presentation/bloc/movies_bloc.dart';
import 'package:flutter/material.dart';

class PopularMovies extends StatefulWidget {
  const PopularMovies({super.key, required this.moviesBloc});

  final MoviesBloc moviesBloc;

  @override
  State<PopularMovies> createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  @override
  void initState() {
    super.initState();
    widget.moviesBloc.initialize();
    widget.moviesBloc.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Popular Movies')),
        body: StreamBuilder<List<Movie>>(
          stream: widget.moviesBloc.moviesStream,
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
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
