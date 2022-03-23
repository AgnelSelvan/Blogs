import 'package:flutter/material.dart';
import 'package:in_app_update_flutter_desktop/application.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In App Updates in Flutter Desktop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'In App Updates in Flutter Desktop App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  showUpdateDialog() {}
  void _checkForUpdates() {
    showUpdateDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Version is ${ApplicationConfig.currentVersion}',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkForUpdates,
        tooltip: 'Check for Updates',
        child: const Icon(Icons.update),
      ),
    );
  }
}
