import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scrollable Positioned Item'),
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
  int selectedIndex = 0;
  final _scrollController = ScrollController();
  final double _size = 50;
  final double _margin = 10;
  final listCount = 10;

  void scrollLeft() {
    _scrollController.animateTo(
      -(listCount * selectedIndex.toDouble() -
          (selectedIndex.toDouble() * _size)),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void scrollRight() {
    _scrollController.animateTo(
      listCount * selectedIndex.toDouble() + (selectedIndex.toDouble() * _size),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  if (selectedIndex == 0) {
                    return;
                  }
                  selectedIndex--;
                  scrollLeft();
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_left)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: List.generate(
                    listCount,
                    (index) => Container(
                      width: _size,
                      height: _size,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? Colors.grey[400] : null,
                      ),
                      margin: EdgeInsets.all(_margin),
                      child: Text("${index + 1}"),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  if (selectedIndex >= (listCount - 1)) {
                    return;
                  }
                  selectedIndex++;
                  scrollRight();
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_right)),
          ],
        ),
      ),
    );
  }
}
