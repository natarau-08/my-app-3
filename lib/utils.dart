
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'global_keys.dart';

sealed class Utils {

  static Future<void> showMessage(String message, Color? backgroundColor, Color? textColor) async {
    while(GlobalKeys.scaffoldMessengerKey.currentState == null) {
      await Future.delayed(const Duration(seconds: 1));
    }

    GlobalKeys.scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor
          ),
        ),
        backgroundColor: backgroundColor,
      )
    );
  }

  static void errorMessage(String message){
    showMessage(message, GlobalKeys.colorScheme?.error, GlobalKeys.colorScheme?.onError);
  }

  static void successMessage(String message){
    showMessage(message, Colors.green, Colors.white);
  }

  static void infoMessage(String message){
    showMessage(message, null, null);
  }

  static void warningMessage(String message){
    showMessage(message, Colors.amber[800], Colors.black);
  }

  static Future<bool> confirm(BuildContext context, String title, String content) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    return r != null && r;
  }

  static String formatDateTimeLong(DateTime dt){
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(dt);
  }

  static String formatDate(DateTime dt){
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dt);
  }

  static DateTime addMonths(DateTime originalDate, int monthsToAdd) {
    // Calculate the new year and month
    int newYear = originalDate.year + ((originalDate.month + monthsToAdd - 1) ~/ 12);
    int newMonth = (originalDate.month + monthsToAdd - 1) % 12 + 1;

    // Calculate the last day of the new month
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;

    // Preserve the day, adjusting if the current day exceeds the new month's last day
    int newDay = originalDate.day <= lastDayOfNewMonth
        ? originalDate.day
        : lastDayOfNewMonth;

    // Return the new DateTime
    return DateTime(newYear, newMonth, newDay, originalDate.hour, originalDate.minute, originalDate.second, originalDate.millisecond, originalDate.microsecond);
  }
}