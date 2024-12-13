
import 'package:drift/drift.dart';

import '../../app_settings_keys.dart';
import '../../pages/home_page.dart';
import '../database.dart';
import '../tables/app_settings.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(
    tables: [AppSetting]
)
class AppSettingDao extends DatabaseAccessor<AppDatabase> with _$AppSettingDaoMixin {
  AppSettingDao(super.db);

  Future<void> _setValue(final int key, final String? value) async {
    final entity = AppSettingCompanion(
        key: Value(key),
        value: value == null ? const Value.absent() : Value(value)
    );

    await into(appSetting).insert(
        entity,
        onConflict: DoUpdate(
                (old) => entity
        )
    );
  }

  Future<String?> _getValue(final int key) async {
    return await (
        select(appSetting)
          ..where((x) => x.key.equals(key))
    )
        .map((x) => x.value)
        .getSingleOrNull();
  }

  Future<void> saveRouteAsLastRestoreRoute(String route) async {
    final key = await _getValue(AppOpenBehavior.key) ?? AppOpenBehavior.restoreLastPage;
    if(key != AppOpenBehavior.restoreLastPage) return;
    await _setValue(AppOpenBehavior.keyRoute, route);
  }

  Future<String> getRestoreRoute () async => await _getValue(AppOpenBehavior.keyRoute) ?? HomePage.route;

  // called from settings
  Future<void> saveRouteAsRestoreThisRoute(String route) async {
    await _setValue(AppOpenBehavior.keyRoute, route);
    await _setValue(AppOpenBehavior.key, AppOpenBehavior.restoreSpecificPage);
  }

  Stream<Map<int, String?>> watchAllSettingsMap() {
    return select(appSetting)
        .watch()
        .map((rows) {
      final map = <int,String?>{};
      for(var x in rows){
        map[x.key] = x.value;
      }
      return map;
    });
  }
}