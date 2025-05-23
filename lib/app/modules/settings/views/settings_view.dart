import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/const/size.dart';
import 'package:maps/app/global/language_selector.dart';
import 'package:maps/app/global/theme_switcher.dart';

class SettingsView extends GetView {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Text(
                "Language".tr,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 17),
              ),
              horizontalTitleGap: getWidth(context, 0.35),
              trailing: LanguageSelector(),
            ),
            Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
            ListTile(
              horizontalTitleGap: getWidth(context, 0.6),
              trailing: ThemeSwitcher(),
              leading: Text(
                "Mode".tr,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 17),
              ),
            ),
            Divider(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}
