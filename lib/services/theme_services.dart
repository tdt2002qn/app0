import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode) =>
      _box.write(_key, isDarkMode); // Lưu chủ đề (theme) vào GetStorage
  bool _loadThemeFromBox() =>
      _box.read(_key) ??
      false; // Đọc chủ đề từ GetStorage, mặc định là chế độ sáng

  ThemeMode get theme => _loadThemeFromBox()
      ? ThemeMode.dark
      : ThemeMode.light; // Lấy chủ đề hiện tại

  // Chuyển đổi giữa chủ đề sáng và tối
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
