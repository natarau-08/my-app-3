
import 'package:flutter/material.dart';

class ExpandingWidget extends StatelessWidget {
  final bool open;
  final String title;
  final void Function() onTap;
  final List<Widget> children;

  const ExpandingWidget({super.key, required this.open, required this.title, required this.onTap, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Icon(open ? Icons.expand_less : Icons.expand_more)
              ],
            ),
          ),
        ),

        if(open)
          ...children
      ]
    );
  }
  
}