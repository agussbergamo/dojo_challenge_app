import 'package:dojo_challenge_app/presentation/screens/popular_movies.dart';
import 'package:dojo_challenge_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasource/local/database_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = await DatabaseService.getInstance();

  runApp(
    ProviderScope(
      overrides: [databaseServiceProvider.overrideWithValue(databaseService)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dojo Challenge App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: const MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/popular-movies': (BuildContext context) => PopularMovies(),
        },
      ),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Movies app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Wanna see some popular movies?'),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/popular-movies');
              },
              child: Text('Take me there!'),
            ),
          ],
        ),
      ),
    );
  }
}
