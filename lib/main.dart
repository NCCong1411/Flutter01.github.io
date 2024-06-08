import 'package:flutter/material.dart';
import 'package:note_app/pages/home_page.dart';
import 'package:note_app/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // Sử dụng ChangeNotifierProvider để cung cấp một đối tượng ThemeProvider cho ứng dụng.
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

// MyApp là widget chính của ứng dụng.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sử dụng Consumer để lắng nghe thay đổi trong ThemeProvider và cập nhật giao diện của ứng dụng.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // MaterialApp là widget cung cấp cơ sở cho ứng dụng Flutter.
        return MaterialApp(
          title: 'Note App', // Tiêu đề của ứng dụng.
          debugShowCheckedModeBanner: false, // Ẩn chữ "debug" trên banner.
          theme: themeProvider.isDarkMode
              ? ThemeData.dark()
              : ThemeData.light(), // Chủ đề của ứng dụng.
          home: HomePage(), // Trang chính của ứng dụng.
        );
      },
    );
  }
}
