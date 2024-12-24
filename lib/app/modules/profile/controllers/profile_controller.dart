import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../data/user_info.dart';

class ProfileController extends GetxController {
  final UserStorageService userStorageService = UserStorageService();
  var profileImage = Rx<File?>(null); 
  var userName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  void loadUserData() {
    userName.value = userStorageService.name ?? "Unknown User";
    email.value = userStorageService.email ?? "No Email";
    phoneNumber.value = userStorageService.phone ?? "No Phone";

    print("Loaded User Data: Name=${userName.value}, Email=${email.value}, Phone=${phoneNumber.value}");
  }

  void deleteAccount() {
    userStorageService.clearUserData();
    profileImage.value = null;
    userName.value = "Unknown User";
    email.value = "No Email";
    phoneNumber.value = "No Phone";
    Get.snackbar("Account".tr, "Account deleted successfully".tr,
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
