
import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';
  static const String title = 'Home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppMainPage(
      title: title,
      body: Placeholder(child: Text(title),),
    );
  }
}