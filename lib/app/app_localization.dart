import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class AppLocalization {

  AppLocalization(this.locale);
  final Locale locale;

  //it will hold key of text and it's values in given language
  late Map<String, String> _localizedValues;

  //to access app-localization instance any where in app using context
  static AppLocalization? of(final BuildContext context) => Localizations.of(context, AppLocalization);

  //to load json(language) from assets
  Future<void> loadJson() async {
    final languageJsonName = locale.countryCode == null
        ? locale.languageCode
        : "${locale.languageCode}-${locale.countryCode}";
      final String jsonStringValues =
        await rootBundle.loadString('assets/languages/$languageJsonName.json');
    //value from root-bundle will be encoded string
    final Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((final key, final value) => MapEntry(key, value.toString()));
  }

  //to get translated value of given title/key
  String? getTranslatedValues(final String? key) => _localizedValues[key!];

  //need to declare custom delegate
  static const LocalizationsDelegate<AppLocalization> delegate = _AppLocalizationDelegate();
}

//Custom app delegate
class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  //providing all supported languages
  @override
  bool isSupported(final Locale locale) {
    //
    return appLanguages
        .map(
          (final appLanguage) => UiUtils.getLocaleFromLanguageCode(appLanguage.languageCode),
        )
        .toList()
        .contains(locale);
  }

  //load languageCode.json files
  @override
  Future<AppLocalization> load(final Locale locale) async {
    final AppLocalization localization = AppLocalization(locale);
    await localization.loadJson();
    return localization;
  }

  @override
  bool shouldReload(final LocalizationsDelegate<AppLocalization> old) => false;
}
