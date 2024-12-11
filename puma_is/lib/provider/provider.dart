import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
  late SharedPreferences storage;

  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
  );

  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );

  // Corrected the `changeTheme` function and other errors
  changeTheme() {
    _isDark = !_isDark;  // Fixed the mistake here
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  // Fixed the init method and initialization of storage
  init() async {
    storage = await SharedPreferences.getInstance();  // Fixed the typo here
    _isDark = storage.getBool("isDark") ?? false;
    notifyListeners();
  }
}
