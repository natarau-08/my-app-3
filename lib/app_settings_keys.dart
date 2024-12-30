
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_app_3/floor/app_database.dart';

sealed class AppOpenBehavior {
  static const int key = 1;
  static const String restoreLastPage = '1';
  static const String restoreSpecificPage = '2';

  static const int keyRoute = 2;
}

sealed class ExpensesSettings {
  static const int keySummaryBackgroundColor = 3;
  static const int keyEvenRowBackgroundColor = 4;
  static const int keyOddRowBackgroundColor = 5;
}

sealed class DarkModeSettings {
  static const int key = 6;
  static const String darkMode = '1';
  static const String lightMode = '2';
  static const String platform = '3';

  static Future<Brightness> getBrightness() async {
    final value = await AppDatabase.instance.appSettingsDao.getValue(key);
    return switch(value){
      darkMode => Brightness.dark,
      lightMode => Brightness.light,
      _ => SchedulerBinding.instance.platformDispatcher.platformBrightness
    };
  }
}