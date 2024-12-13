import 'package:flutter/material.dart';
import 'package:my_app_3/database/database.dart';

import 'global_keys.dart';
import 'route_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.instance = AppDatabase();

  // get route to be restored
  final route = await AppDatabase.appSettingsDao.getRestoreRoute();

  AppDatabase.instance.scheduledExpenseDao.generateExpenses();

  runApp(MainApp(initialRoute: route));
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MaterialApp(
      scaffoldMessengerKey: GlobalKeys.scaffoldMessengerKey,
      navigatorKey: GlobalKeys.navigatorKey,
      routes: {
        for(var ri in RouteInfo.routeList)
          ri.route: ri.routeBuilder
      },
      initialRoute: initialRoute,

      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding: EdgeInsets.only(bottom: 8, top: 2)
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: cs.primary,
          titleTextStyle: TextStyle(
            color: cs.onPrimary,
            fontSize: 20,
            // fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(
            color: cs.onPrimary
          )
        ),

        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(horizontal: 8)
          )
        ),
      ),
    );
  }
}