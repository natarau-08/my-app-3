
import 'package:flutter/material.dart';

class ElevatedCancelButton extends StatelessWidget{
  final void Function() onPressed;

  const ElevatedCancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text('Cancel'),
      icon: const Icon(Icons.cancel),
    );
  }
}