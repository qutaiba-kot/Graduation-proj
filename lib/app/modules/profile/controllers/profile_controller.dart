import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../data/user_info.dart';

class ProfileController extends GetxController {
  // كائن الوصول إلى التخزين المحلي
  final UserStorageService userStorageService = UserStorageService();

  // متغيرات لمعلومات المستخدم
  var profileImage = Rx<File?>(null); // يجب أن تكون كـ Rx
  var userName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // تحميل البيانات من التخزين المحلي عند تهيئة الـ Controller
    loadUserData();
  }

  // دالة لتحميل البيانات المخزنة
  void loadUserData() {
    userName.value = userStorageService.name ?? "Unknown User";
    email.value = userStorageService.email ?? "No Email";
    phoneNumber.value = userStorageService.phone ?? "No Phone";

    print("Loaded User Data: Name=${userName.value}, Email=${email.value}, Phone=${phoneNumber.value}");
  }

  // دالة لحذف الحساب
  void deleteAccount() {
    // مسح بيانات المستخدم المخزنة محليًا
    userStorageService.clearUserData();

    // مسح باقي البيانات مثل صورة الملف الشخصي
    profileImage.value = null;
    userName.value = "Unknown User";
    email.value = "No Email";
    phoneNumber.value = "No Phone";

    // إظهار رسالة تأكيد
    Get.snackbar("Account".tr, "Account deleted successfully".tr,
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
