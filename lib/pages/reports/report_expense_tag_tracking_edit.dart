
import 'package:flutter/material.dart';
import 'package:my_app_3/app_secondary_page.dart';
import 'package:my_app_3/forms/edit_tag_tracking_form.dart';

class ReportExpenseTagTrackingEdit extends StatelessWidget{
  static const route = '/rep/ett/edit';

  const ReportExpenseTagTrackingEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSecondaryPage(
      title: 'Edit expense tag tracking',
      child: EditTagTrackingForm()
    );
  }
}