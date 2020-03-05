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
      'remove_poop_title': 'Ta bort bajsning',
      'remove_poop_question': 'Är du säker på att du vill ta bort bajsningen?',
      'remove': 'Ta bort',
      'add': 'Lägg till',
      'cancel': 'Avbryt',
      'removed': ' borttagen',
      'add_poop_title': 'Lägg till ny bajsning',
      'change_date': 'Ändra dag/tid',
      'popular_pooptime': 'Du brukar bajsa på ',
      'night': 'natt',
      'the_night': 'natten',
      'morning': 'morgon',
      'the_morning': 'morgonen',
      'afternoon': 'eftermiddag',
      'the_afternoon': 'eftermiddagen',
      'evening': 'kväll',
      'the_evening': 'kvällen',
      'poops_per_hour': 'Bajsningar per timme',
      'poops_per_time_of_day': 'Bajsningar per tid på dygnet',
      'time_statistics': 'Tidsstatistik',
      'type_1_description': 'Separata hårda klumpar, som nötter (svåra att klämma ut)',
      'type_2_description': 'Korvformade, med klumpar',
      'type_3_description': 'Som en korv med sprickor på dess yta',
      'type_4_description': 'Som en korv eller orm, jämn och mjuk',
      'type_5_description': 'Mjuka klumpar med tydliga kanter (lätta att klämma ut)',
      'type_6_description': 'Fluffiga bitar med trasade kanter, en mosig konsistens',
      'type_7_description': 'Vattnig utan bitar. Helt flytande.',
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