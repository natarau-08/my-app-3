
import 'package:flutter/material.dart';
import 'package:my_app_3/app_main_page.dart';
import 'package:my_app_3/app_settings_keys.dart';
import 'package:my_app_3/pages/backup_and_restore_page.dart';
import 'package:my_app_3/route_info.dart';

import '../constants.dart';
import '../controls/centered_widgets.dart';
import '../database/database.dart';

class SettingsPage extends StatefulWidget {
  static const String title = 'Settings';
  static const String route = '/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Stream<Map<int,String?>> _stream;

  late List<DropdownMenuEntry<RouteInfo?>> _options;

  @override
  void initState() {
    _stream = AppDatabase.appSettingsDao.watchAllSettingsMap();

    _options = [
      const DropdownMenuEntry(
        value: null,
        label: 'Restore last page'
      ),

      for(var ri in RouteInfo.routeMenuList)
        DropdownMenuEntry(
          value: ri,
          label: 'Restore ${ri.title}',
          trailingIcon: ri.menuIcon
        ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppMainPage(
      title: SettingsPage.title,
      actions: [
        IconButton(
          onPressed: () => showAboutDialog(
            context: context,
            applicationName: 'My App 3',
            applicationVersion: '1.0',
          ),
          icon: const Icon(Icons.info)
        )
      ],
      // body: const Placeholder(),
      body: Padding(
        padding: const EdgeInsets.all(Constants.pagePadding),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            final w = SimpleProgressIndicator.handleSnapshotForLoadingOrError(snapshot);
            if(w != null) return w;
        
            final settingsMap = snapshot.data!;
        
            return ListView(
              children: [
                Column(
                  children: [
                    const Row(
                      children: [
                        Text('When I open the app', style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    // const Divider(height: 1,),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownMenu<RouteInfo?>(
                            dropdownMenuEntries: _options,
                            enableSearch: true,
                            expandedInsets: const EdgeInsets.all(0),
                            initialSelection: (settingsMap[AppOpenBehavior.keyRoute] == null || settingsMap[AppOpenBehavior.key] == AppOpenBehavior.restoreLastPage
                              || settingsMap[AppOpenBehavior.key] == null
                            ) ? null : RouteInfo.routeMenuList.firstWhere((x) => x.route == settingsMap[AppOpenBehavior.keyRoute]),
                            onSelected: (ri) {
                              if(ri == null) return;
                              AppDatabase.appSettingsDao.saveRouteAsRestoreThisRoute(ri.route);
                            },
                          ),
                        )
                      ],
                    ),
        
                    const SizedBox(height: 4,),
                  ],
                ),

                // Column(
                //   children: [
                //     const Row(
                //       children: [
                //         Text('Expense list appearance', style: TextStyle(fontWeight: FontWeight.bold),)
                //       ],
                //     ),

                //     Row(
                //       children: [
                //         const Expanded(child: Text('Summary background color:')),
                //         Expanded(
                //           child: Container(
                //             color: Colors.red,
                //           ),
                //         )
                //       ],
                //     )
                //   ],
                // ),

                ListTile(
                  title: const Text(BackupAndRestorePage.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(BackupAndRestorePage.route);
                  },
                )
              ],

            );
          }
        ),
      )
    );    
  }
}