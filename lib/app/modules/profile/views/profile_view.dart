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
                  Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: controller.profileImage.value == null
                            ? AssetImage("lib/app/assets/images/OIP.jpeg")
                                as ImageProvider
                            : FileImage(controller.profileImage.value!),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
                  controller.userName.value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )),

            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "email".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Obx(() => Text(
                    controller.email.value,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.phone,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(
                "phone".tr,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              subtitle: Obx(() => Text(
                    controller.phoneNumber.value,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
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
              onPressed: ()  { },
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
