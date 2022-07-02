import 'package:flavor_demo/enum/flavors.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final Flavor flavor;
  const MyApp({Key? key, required this.flavor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flavor Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(flavor.name),
        ),
      ),
    );
  }
}
