import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "profile".tr,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.getProfileImage(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {Get.snackbar(
                  "This feature will be added soon".tr,
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                );},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              ' ${controller.userStorage.name ?? "unavailable".tr}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            ListTile(
              leading: Icon(Icons.email,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "email".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                ' ${controller.userStorage.email ?? "unavailable".tr}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "phone".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                ' ${controller.userStorage.phone ?? "unavailable".tr}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "Score".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                ' ${controller.userStorage.trustedScore ?? "unavailable".tr}' +
                    "%",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.report,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "My total reports".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                ' ${controller.userStorage.totalReports ?? "unavailable".tr}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () {
    Get.toNamed("/archive"); // استبدل ReportsPage بالصفحة التي تريد الانتقال إليها
  },
            ),
            ListTile(
              leading: Icon(Icons.numbers,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "user id".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Text(
                ' ${controller.userStorage.userId ?? "unavailable".tr}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {Get.snackbar(
                  "This feature will be added soon".tr,
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                );},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
              ),
              child: Text(
                "reset_password".tr,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  "This feature will be added soon".tr,
                  "",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(
                "delete_account".tr,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
