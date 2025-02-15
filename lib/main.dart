import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maps/app/AppTranslations/translations.dart';
import 'package:maps/app/theme/app_theme.dart';
import 'app/data/user_info.dart';
import 'app/routes/app_pages.dart';
import 'app/supabase_config.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initSupabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetStorage storage = GetStorage();
  final UserStorageService userStorage = UserStorageService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khaberni',
      theme: AppTheme.light.copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white.withOpacity(0.3),
          selectionHandleColor: Colors.white,
        ),
      ),
      darkTheme: AppTheme.dark.copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black.withOpacity(0.3),
          selectionHandleColor: Colors.black,
        ),
      ),
      themeMode: _getThemeMode(),
      initialRoute: _getInitialRoute(),
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: Locale(storage.read('lang') ?? 'en'),
    );
  }

  ThemeMode _getThemeMode() {
    final bool isDarkMode = GetStorage().read('isDarkMode') ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  String _getInitialRoute() {
    if (userStorage.isLoggedIn) {
      return '/map';
    } else {
      return AppPages.INITIAL;
    }
  }
}
