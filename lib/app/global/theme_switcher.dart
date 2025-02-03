import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';

class ThemeSwitcher extends StatefulWidget {
  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  late bool isDarkMode;
  void restartApp() {
    Restart.restartApp(
      /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
      // webOrigin: 'http://example.com',

      // Customizing the restart notification message (only needed on iOS)
      notificationTitle: 'Restarting App',
      notificationBody: 'Please tap here to open the app again.',
    );
  }

  @override
  void initState() {
    super.initState();
    isDarkMode = GetStorage().read('isDarkMode') ?? false;
  }

  void toggleTheme() {
    if (Get.currentRoute == '/settings') {
      Get.dialog(
        AlertDialog(
          title: Text('Alert'.tr),
          content: Text("Some changes will require a restart of the application.".tr),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                setState(() {
                  isDarkMode = !isDarkMode;
                });
                Get.changeThemeMode(
                    isDarkMode ? ThemeMode.dark : ThemeMode.light);
                GetStorage().write('isDarkMode', isDarkMode);
                restartApp();
              },
              child: Text('OK'.tr),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                setState(() {
                  isDarkMode = !isDarkMode;
                });
                Get.changeThemeMode(
                    isDarkMode ? ThemeMode.dark : ThemeMode.light);
                GetStorage().write('isDarkMode', isDarkMode);
              },
              child: Text('Just change the theme'.tr),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        isDarkMode = !isDarkMode;
      });
      Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
      GetStorage().write('isDarkMode', isDarkMode);
    }
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
