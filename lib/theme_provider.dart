import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ThemeProvider là lớp cung cấp chế độ giao diện tối hoặc sáng cho ứng dụng và lưu trữ thông tin trạng thái này trong SharedPreferences.
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  // Phương thức getter isDarkMode để truy xuất trạng thái giao diện tối/sáng từ bên ngoài lớp.
  bool get isDarkMode => _isDarkMode;

  // Constructor của lớp ThemeProvider, khởi động quá trình load dữ liệu từ SharedPreferences.
  ThemeProvider() {
    _loadFromPrefs();
  }

  // Phương thức toggleTheme để chuyển đổi giữa chế độ giao diện tối và sáng.
  toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }

  // Phương thức _loadFromPrefs để load trạng thái giao diện từ SharedPreferences.
  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ??
        false; // Load trạng thái từ SharedPreferences, nếu không có sẽ mặc định là false (chế độ sáng).
    notifyListeners();
  }

  // Phương thức _saveToPrefs để lưu trạng thái giao diện vào SharedPreferences.
  _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }
}
