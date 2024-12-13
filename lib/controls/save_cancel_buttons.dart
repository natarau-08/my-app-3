
import 'package:flutter/material.dart';
import 'package:my_app_3/controls/icon_text_button.dart';

class SaveCancelButtons extends StatelessWidget {
  final void Function()? onSave;
  final void Function()? onCancel;

  const SaveCancelButtons({
    super.key,
    required this.onSave,
    required this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: IconTextButton(
            onPressed: onCancel,
            text: 'Cancel',
            icon: const Icon(Icons.arrow_back)
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          child: IconTextButton(
            onPressed: onSave,
            text: 'Save',
            icon: const Icon(Icons.save)
          ),
        )
      ],
    );
  }
}