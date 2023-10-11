import 'dart:convert';

import 'package:http/http.dart';
import 'package:localization_demo/models/locale.dart';

class TranslationFromGithub {
  static Future<Map<String, dynamic>> getTranslations() async {
    final translationResponse = await get(
      Uri.parse(
        'https://raw.githubusercontent.com/AgnelSelvan/Blogs/main/localization/translations/translations.json',
      ),
    );

    return jsonDecode(translationResponse.body);
  }

  static Future<Map<String, dynamic>> getLocalizationData(
      {required String languageCode}) async {
    final arResponse = await get(
      Uri.parse(
        'https://raw.githubusercontent.com/AgnelSelvan/Blogs/main/localization/translations/$languageCode.json',
      ),
    );

    return jsonDecode(arResponse.body);
  }

  static Future<Map<String, dynamic>> getLocalizationDataFromGithub() async {
    Map<String, dynamic> finalData = {};

    final translationJson = await TranslationFromGithub.getTranslations();

    List<AppLocale> supportedLocale = [];
    final locs = translationJson['locale'];
    if (locs is List) {
      for (var loc in locs) {
        final locale = AppLocale(
          localeName: '${loc["name"]}',
          languageCode: '${loc["languageCode"]}',
        );
        supportedLocale.add(locale);
        final arJson = TranslationFromGithub.getLocalizationData(
            languageCode: locale.languageCode);
        finalData.addAll({locale.languageCode: arJson});
      }
    }

    AppLocale.supportedLocales = supportedLocale;
    return finalData;
  }
}
