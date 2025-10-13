
import 'package:flutter/material.dart';

class ElevatedSaveButton extends StatelessWidget{
  final Function()? onPressed;

  const ElevatedSaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.save),
      label: const Text('Save'),
    );
  }
}