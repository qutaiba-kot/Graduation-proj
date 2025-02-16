import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/drawer_controller.dart';

class LogoutDialog {
  static void showLogoutDialog(BuildContext context) {
    MyDrawerController controller = MyDrawerController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Are you sure you\'re logged out?'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: Text(
          'You will be logged out of the existing account. Do you want to continue the process?'
              .tr,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.logout();
                  Get.back();
                },
                child: Text(
                  'logout'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
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
  }
}
