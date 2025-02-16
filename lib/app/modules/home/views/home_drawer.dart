import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/drawer_controller.dart';
import '../../../data/user_info.dart';
import '../../../widgets/contact_dialog.dart';
import '../../../widgets/logout_dialog.dart';

class MyDrawer extends GetView<MyDrawerController> {

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
            onTap: () => {Get.toNamed("/archive")},
          ),
          ListTile(
            leading: Icon(Icons.leaderboard,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "leaderboard".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => Get.toNamed('/lead-board'),
          ),
          ListTile(
            leading: Icon(Icons.help_outline,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "help".tr + " ؟ " + "Call Us".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => ContactDialog.showContactDialog(context),
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
          ListTile(
            leading: Icon(Icons.logout,
                color: Theme.of(context).colorScheme.error),
            title: Text(
              "logout".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => LogoutDialog.showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
