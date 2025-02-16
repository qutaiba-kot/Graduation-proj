import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDialog {
  static void showContactDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "For any comments or problems please contact".tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "+962786233247",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
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
                    Get.snackbar("Error", "Could not launch the phone app.");
                  }
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.call),
                    SizedBox(width: 10),
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
      barrierDismissible: true,
    );
  }
}
