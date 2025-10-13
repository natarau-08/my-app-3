

import 'package:flutter/material.dart';

class ElevatedDeleteButton extends StatelessWidget {
  final void Function() onPressed;

  const ElevatedDeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text('Delete'),
      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
    );
  }
}