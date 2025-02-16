import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';

class ThemeSwitcher extends StatelessWidget {
  ThemeSwitcher({Key? key}) : super(key: key);

  final box = GetStorage();
  final bool isDarkMode = GetStorage().read('isDarkMode') ?? false;

  void restartApp() {
    Restart.restartApp(
      notificationTitle: 'Restarting App',
      notificationBody: 'Please tap here to open the app again.',
    );
  }

  void toggleTheme(BuildContext context) {
    if (Get.currentRoute == '/settings') {
      Get.dialog(
        AlertDialog(
          title: Text('Alert'.tr),
          content: Text("Some changes will require a restart of the application.".tr),
          actions: [
            TextButton(
              onPressed: () {
                bool newThemeMode = !isDarkMode;
                box.write('isDarkMode', newThemeMode);
                Get.changeThemeMode(newThemeMode ? ThemeMode.dark : ThemeMode.light);
                Get.back();
                restartApp();
              },
              child: Text('OK'.tr),
            ),
            TextButton(
              onPressed: () {
                bool newThemeMode = !isDarkMode;
                box.write('isDarkMode', newThemeMode);
                Get.changeThemeMode(newThemeMode ? ThemeMode.dark : ThemeMode.light);
                Get.back();
              },
              child: Text('Just change the theme'.tr),
            ),
          ],
        ),
      );
    } else {
      bool newThemeMode = !isDarkMode;
      box.write('isDarkMode', newThemeMode);
      Get.changeThemeMode(newThemeMode ? ThemeMode.dark : ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      onPressed: () => toggleTheme(context),
      tooltip: isDarkMode ? "Switch to light mode" : "Switch to dark mode",
    );
  }
}
