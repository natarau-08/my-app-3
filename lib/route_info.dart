import 'package:flutter/material.dart';
import 'package:my_app_3/pages/add_expense_page.dart';
import 'package:my_app_3/pages/car_page.dart';
import 'package:my_app_3/pages/deleted_tags_page.dart';
import 'package:my_app_3/pages/edit_expense_page.dart';
import 'package:my_app_3/pages/backup_and_restore_page.dart';
import 'package:my_app_3/pages/edit_scheduled_expense_page.dart';
import 'package:my_app_3/pages/home_page.dart';
import 'package:my_app_3/pages/reports/report_ct.dart';
import 'package:my_app_3/pages/reports_page.dart';
import 'package:my_app_3/pages/scheduled_expenses_page.dart';
import 'package:my_app_3/pages/settings_page.dart';

import 'constants.dart';
import 'pages/edit_tag_page.dart';
import 'pages/expense_list_page.dart';
import 'pages/tags_page.dart';

class RouteInfo {
  static final routeList = [
    // main menu routes: they have title and icon
    RouteInfo(HomePage.title, HomePage.route, (context) => const HomePage(), menuIcon: const Icon(Icons.home, color: Colors.blue,)),
    RouteInfo(AddExpensePage.title, AddExpensePage.route, (context) => const AddExpensePage(), menuIcon: const Icon(Icons.euro, color: Constants.colorGold,)),
    RouteInfo(TagsPage.title, TagsPage.route, (context) => const TagsPage(), menuIcon: const Icon(Icons.tag, color: Constants.colorBlue,)),
    RouteInfo(ExpenseListPage.title, ExpenseListPage.route, (context) => const ExpenseListPage(), menuIcon: const Icon(Icons.list)),
    RouteInfo(ReportsPage.title, ReportsPage.route, (context) => const ReportsPage(), menuIcon: const Icon(Icons.auto_graph, color: Constants.colorBlue,)),
    RouteInfo(CarPage.title, CarPage.route, (context) => const CarPage(), menuIcon: const Icon(Icons.directions_car, color: Colors.green,)),

    // other routes: title is null => they do not appear in the main menu
    RouteInfo(null, EditTagPage.route, (context) => const EditTagPage()),
    RouteInfo(null, SettingsPage.route, (context) => const SettingsPage()),
    RouteInfo(null, DeletedTagsPage.route, (context) => const DeletedTagsPage()),
    RouteInfo(null, EditExpensePage.route, (context) => const EditExpensePage()),
    RouteInfo(null, BackupAndRestorePage.route, (context) => const BackupAndRestorePage()),
    RouteInfo(null, ScheduledExpensesPage.route, (context) => const ScheduledExpensesPage()),
    RouteInfo(null, EditScheduledExpensePage.route, (context) => const EditScheduledExpensePage()),
    RouteInfo(null, ReportCt.route, (context) => const ReportCt()),
  ];

  static final routeMenuList = routeList.where((x) => x.title != null);

  final String? title;
  final String route;
  final Widget Function(BuildContext context) routeBuilder;
  final Icon? menuIcon;
  const RouteInfo(this.title, this.route, this.routeBuilder, {this.menuIcon});
}