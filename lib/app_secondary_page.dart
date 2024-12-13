
import 'package:flutter/material.dart';

class AppSecondaryPage extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const AppSecondaryPage({
    super.key,
    required this.title,
    required this.child,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: child,
    );
  }
}