import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../data/user_info.dart';
class ProfileController extends GetxController {
  final UserStorageService userStorage = UserStorageService();
  var profileImage = Rx<File?>(null);

  ImageProvider getProfileImage() {
    if (profileImage.value == null) {
      return const AssetImage("lib/app/assets/images/OIP.jpeg");
    } else {
      return FileImage(profileImage.value!);
    }
  }
}
