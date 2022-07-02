import 'package:flavor_demo/app.dart';
import 'package:flavor_demo/enum/flavors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(
      flavor: Flavor.development,
    ),
  );
}
