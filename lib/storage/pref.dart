import 'package:shared_preferences/shared_preferences.dart';

class PrefKey {
  static const String id = "id";
}

class Pref {
  SharedPreferences? _pref;

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<int> get(String key) async {
    try {
      if (_pref == null) await init();
      return _pref!.getInt(key) ?? -1;
    } catch (e) {
      return -1;
    }
  }

  Future<void> set(String key, int value) async {
    try {
      if (_pref == null) await init();
      await _pref!.setInt(key, value);
    } catch (e) {
      print(e);
    }
  }
}
