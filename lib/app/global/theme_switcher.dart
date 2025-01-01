import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeSwitcher extends StatefulWidget {
  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = GetStorage().read('isDarkMode') ?? false;
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    GetStorage().write('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      onPressed: toggleTheme,
      tooltip: isDarkMode ? "Switch to light mode" : "Switch to dark mode",
    );
  }
}
