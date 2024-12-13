
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Icon icon;
  const IconTextButton({super.key, required this.onPressed, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 4,),
          Text(text)
        ],
      )
    );
  }
}