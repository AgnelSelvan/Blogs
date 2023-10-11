import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localization_demo/app.dart';
import 'package:localization_demo/models/locale.dart';
import 'package:localization_demo/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Map<String, dynamic> finalData =
      await TranslationFromGithub.getLocalizationDataFromGithub();

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
