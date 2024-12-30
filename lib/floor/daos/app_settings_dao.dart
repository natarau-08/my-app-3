
import 'package:floor/floor.dart';
import 'package:my_app_3/app_settings_keys.dart';
import 'package:my_app_3/floor/tables/app_settings.dart';
import 'package:my_app_3/pages/home_page.dart';

@dao
abstract class AppSettingsDao {
  @Insert()
  Future<int?> insert(AppSettings e);

  @Update()
  Future<void> update(AppSettings e);

  @Query('select * from app_settings where `key`=:key')
  Future<AppSettings?> findByKey(int key);

  Future<void> setValue(final int key, final String? value) async {
    var e = await findByKey(key);
    if(e == null){
      e = AppSettings(value: value, key: key);
      await insert(e);
    }
    else{
      e.value = value;
      await update(e);
    }
  }

  Future<String?> getValue(final int key) async {
    return (await findByKey(key))?.value;
  }

  Future<void> saveRouteAsLastRestoreRoute(String route) async {
    final key = await getValue(AppOpenBehavior.key) ?? AppOpenBehavior.restoreLastPage;
    if(key != AppOpenBehavior.restoreLastPage) return;
    await setValue(AppOpenBehavior.keyRoute, route);
  }

  Future<String> getRestoreRoute () async => await getValue(AppOpenBehavior.keyRoute) ?? HomePage.route;

  // called from settings
  Future<void> saveRouteAsRestoreThisRoute(String route) async {
    await setValue(AppOpenBehavior.keyRoute, route);
    await setValue(AppOpenBehavior.key, AppOpenBehavior.restoreSpecificPage);
  }

  @Query('select * from app_settings')
  Stream<List<AppSettings>> watchAll();

  Stream<Map<int, String?>> watchAllSettingsMap(){
    return watchAll().map((list) {
      return { for (var kv in list) kv.key!: kv.value };
    });
  }
}