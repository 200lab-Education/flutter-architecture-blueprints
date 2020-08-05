import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAnalyticsDataSource {
  UserAnalyticsDataSource({@required SharedPreferences prefs}) : _prefs = prefs;

  static const String KEY_IS_FIRST_LAUNCH = 'is_first_launch';

  final SharedPreferences _prefs;

  bool isFirstLaunch() {
    return _prefs.getBool(KEY_IS_FIRST_LAUNCH);
  }

  Future<void> saveFirstLaunch(bool value) async {
    return _prefs.setBool(KEY_IS_FIRST_LAUNCH, value);
  }
}
