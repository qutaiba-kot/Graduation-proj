import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/drawer_controller.dart';

import '../../../data/user_info.dart';

class MyDrawer extends GetWidget {
  final MyDrawerController controller = Get.find<MyDrawerController>();

  final UserStorageService userStorage = UserStorageService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              ' ${userStorage.name ?? "unavailable".tr}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            accountEmail: Text(
              ' ${userStorage.email ?? "unavailable".tr}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("lib/app/assets/images/OIP.jpeg"),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "profile".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => Get.toNamed('/profile'),
          ),
          ListTile(
            leading: Icon(Icons.report,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "report".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => Get.toNamed('/reportation'),
          ),
          ListTile(
            leading: Icon(Icons.archive,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "My total reports".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => {Get.snackbar(
                  "This feature will be added soon".tr,
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                )},
          ),
          ListTile(
            leading: Icon(Icons.help_outline,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "help".tr + " ؟ " + "Call Us".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => Get.snackbar(
                "For any comments or problems please contact".tr,
                "+962786233247",
                colorText: Theme.of(context).colorScheme.background,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            leading: Icon(Icons.settings,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "settings".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => Get.toNamed('/settings'),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                "logout".tr,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                controller.logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
