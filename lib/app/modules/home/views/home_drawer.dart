import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/drawer_controller.dart';
import 'package:url_launcher/url_launcher.dart';

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
            onTap: () => {Get.toNamed("/archive")},
          ),
          ListTile(
            leading: Icon(Icons.help_outline,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "help".tr + " ؟ " + "Call Us".tr,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onTap: () => Get.dialog(
              AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "For any comments or problems please contact".tr,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      "+962786233247",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          String phoneNumber = "+962786233247";
                          final Uri phoneUri = Uri(
                            scheme: 'tel',
                            path: phoneNumber,
                          );
                          if (await canLaunch(phoneUri.toString())) {
                            await launch(phoneUri.toString());
                          } else {
                            Get.snackbar(
                                "Error", "Could not launch the phone app.");
                          }
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.call),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Call".tr),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text("OK".tr),
                      ),
                    ],
                  )
                ],
              ),
              barrierDismissible:
                  true, // يسمح بإغلاق الصندوق عند النقر في مكان آخر
            ),
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
                Get.dialog(
                  AlertDialog(
                    backgroundColor: Theme.of(Get.context!).colorScheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      'Are you sure you\'re logged out?'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(Get.context!).colorScheme.primary,
                      ),
                    ),
                    content: Text(
                      'You will be logged out of the existing account. Do you want to continue the process?'
                          .tr,
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(Get.context!).colorScheme.onBackground),
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              Get.back(); // إغلاق الـ Dialog
                            },
                            child: Text(
                              "Cancel".tr,
                              style: TextStyle(
                                color: Theme.of(Get.context!)
                                    .colorScheme
                                    .background,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.logout(); // تسجيل الخروج
                              Get.back(); // إغلاق الـ Dialog بعد تسجيل الخروج
                            },
                            child: Text(
                              'logout'.tr,
                              style: TextStyle(
                                color: Theme.of(Get.context!)
                                    .colorScheme
                                    .background,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  barrierDismissible: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
