import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class PoopLocalizations {
  PoopLocalizations(this.locale);

  final Locale locale;

  static PoopLocalizations of(BuildContext context) {
    return Localizations.of<PoopLocalizations>(context, PoopLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'sv': {
      'title': 'Bajsappen',
      'home': 'Registrera bajs',
      'statistics': 'Statistik',
      'latest_poop': 'Senaste bajset: ',
      'you_have_pooped': 'Du har bajsat ',
      'times_since': ' gånger sedan ',
      'popular_poopday': 'Din populäraste bajsardag: ',
      'monday': 'Måndag',
      'tuesday': 'Tisdag',
      'wednesday': 'Onsdag',
      'thursday': 'Torsdag',
      'friday': 'Fredag',
      'saturday': 'Lördag',
      'sunday': 'Söndag',
      'weekday_statistics': 'Veckodagsstatistik',
      'weekday_chart_title': 'Totalt antal bajsningar per dag',
      'all_poops': 'Alla registrerade bajsningar',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}


class DemoLocalizationsDelegate extends LocalizationsDelegate<PoopLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['sv'].contains(locale.languageCode);

  @override
  Future<PoopLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<PoopLocalizations>(PoopLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}