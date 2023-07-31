import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:realm_flutter_example/home.dart';
import 'package:realm_flutter_example/provider/quotes.dart';

void main() async {
  final app = App(AppConfiguration("application-0-ctycz",
      baseUrl: Uri.parse("https://realm.mongodb.com")));
  final currentUser =
      app.currentUser ?? (await app.logIn(Credentials.anonymous()));

  runApp(
    ChangeNotifierProvider(
      create: (_) => QuotesNotifier(currentUser),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
