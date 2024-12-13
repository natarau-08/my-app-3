
import 'package:flutter/material.dart';
import 'package:my_app_3/database/database.dart';
import 'package:my_app_3/pages/settings_page.dart';
import 'package:my_app_3/route_info.dart';

class AppMainPage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const AppMainPage({
    required this.title,
    required this.body,
    this.actions,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: actions,
        title: Text(title),
      ),
      drawer: Drawer(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: cs.primary,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My App 3',
                          style: TextStyle(
                            color: cs.onPrimary,
                            fontSize: 20
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed(SettingsPage.route),
                        icon: Icon(
                          Icons.settings,
                          color: cs.onPrimary,
                        )
                      )
                    ],
                  ),
                ],
              )
            ),

            for(var ri in RouteInfo.routeMenuList)
              ListTile(
                title: Text(ri.title!),
                leading: ri.menuIcon,
                onTap: () {
                  AppDatabase.appSettingsDao.saveRouteAsLastRestoreRoute(ri.route);
                  Navigator.of(context).pushReplacementNamed(ri.route);
                },
              )
          ],
        ),
      ),
      body: body,
    );
  }
}