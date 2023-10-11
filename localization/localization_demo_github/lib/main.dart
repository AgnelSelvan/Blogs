import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localization_demo/app.dart';
import 'package:localization_demo/models/locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Map<String, dynamic> finalData = {};

  final translationResponse = await get(
    Uri.parse(
      '',
    ),
  );

  final translationJson = jsonDecode(translationResponse.body);

  List<AppLocale> supportedLocale = [];
  final locs = translationJson['locale'];
  if (locs is List) {
    for (var loc in locs) {
      final locale = AppLocale(
        localeName: '${loc["name"]}',
        languageCode: '${loc["languageCode"]}',
      );
      supportedLocale.add(locale);
      final arResponse = await get(
        Uri.parse(
          '',
        ),
      );
      final arJson = jsonDecode(arResponse.body);
      finalData.addAll({locale.languageCode: arJson});
    }
  }

  AppLocale.supportedLocales = supportedLocale;

  runApp(
    EasyLocalization(
      supportedLocales: AppLocale.supportedLocales
          .map((e) => Locale(e.languageCode))
          .toList(),
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: MyHttpLocalizationLoader(finalData),
      child: const MyApp(),
    ),
  );
}

class MyHttpLocalizationLoader extends AssetLoader {
  final Map<String, dynamic> data;
  const MyHttpLocalizationLoader(this.data);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    return data[locale.toString()];
  }
}
