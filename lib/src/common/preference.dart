import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* 사용법
Setter : Preference().setString("test", "1234"); or Preference().setData("test1", 123);
Getter : Preference().getString("test") / Util.showToast(Preference().getInt("test").toString());
Remove : Preference().remove("test");
 */

class Preference {
  Preference._internal();

  static final _instance = Preference._internal();

  factory Preference() => _instance;

  late SharedPreferences _preference;

  Future init() async {
    _preference = await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    _preference.setString(key, value);
  }

  String getString(String key, {String defValue = ""}) {
    return _preference.getString(key) ?? defValue;
  }

  getInt(String key, {int defValue = -1}) {
    return _preference.getInt(key) ?? defValue;
  }

  getDouble(String key) {
    return _preference.getDouble(key) ?? 0.0;
  }

  bool getBool(String key, {bool defValue = false}) {
    return _preference.getBool(key) ?? defValue;
  }

  setList(String key, List<String> values) {
    _preference.setStringList(key, values);
  }

  getList(String key) {
    return _preference.getStringList(key);
  }

  setData(String key, var value) {
    if (value is String) {
      debugPrint("이거슨 스트링이여");
      _preference.setString(key, value);
    } else if (value is int) {
      debugPrint("이거슨 int여");
      _preference.setInt(key, value);
    } else if (value is double) {
      debugPrint("이거슨 더블이여");
      _preference.setDouble(key, value);
    } else if (value is bool) {
      debugPrint("이거슨 불불이여");
      _preference.setBool(key, value);
    } else {
      debugPrint("타입을 알 수 없다 걍 리턴");
    }
  }

  remove({required String key}) async {
    var success = await _preference.remove(key);
    return success;
  }
}
