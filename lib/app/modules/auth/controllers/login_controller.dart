import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/user_info.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxBool isLoading = false.obs;
  final UserStorageService userStorageService = UserStorageService();
  bool validateEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      emailError.value = "Invalid email format.".tr;
      print("Validation Error: Invalid email format: $email");
      return false;
    }
    emailError.value = '';
    return true;
  }
  bool validatePassword(String password) {print("Validating password...");
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    if (!hasUppercase || !hasDigits || !hasSpecialCharacters || !hasMinLength) {
      passwordError.value =
          "Password must be at least 8 characters long, contain uppercase letters, numbers, and special characters.";
      print("Password validation failed: ${passwordError.value}");
      return false;
    }
    passwordError.value = '';
    print("Password validation passed.");
    return true;
  }
  void login(String email, String password) async {
    if (!validateEmail(email) || !validatePassword(password)) {
      Get.snackbar(
        "Login Failed".tr,
        "Please correct the errors and try again.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isLoading.value = true;

    try {
      print("🚀 Starting login process...");
      print("📧 Email: $email");
      print("Fetching user data from Supabase...");
      final additionalData = await Supabase.instance.client
          .from('users')
          .select('id, email, name, phone, password_hash, trusted_score, total_reports')
          .eq('email', email)
          //.eq('password_hash' ,password )
          .single();
      print("Data fetched from Supabase: $additionalData");
      if (additionalData == false || additionalData.isEmpty) {
        print("❌ No user found with the provided email.");
        throw Exception("Invalid email or password.");
      }
      final userId = additionalData['id'] ?? 'Unknown';
      final userEmail = additionalData['email'] ?? 'Unknown';
      final name = additionalData['name'] ?? 'Unknown';
      final phone = additionalData['phone'] ?? 'Unknown';
      final trustedScore = additionalData['trusted_score'] ?? 0;
      final totalReports = additionalData['total_reports'] ?? 0;
      print(
          "Parsed Data -> UserID: $userId, Email: $userEmail, Name: $name, Phone: $phone, Trusted Score: $trustedScore, Total Reports: $totalReports");
      print("Saving user data locally...");
      userStorageService.saveUserData(
        email: userEmail,
        phone: phone,
        name: name,
        userId: userId,
        trustedScore: trustedScore,
        totalReports: totalReports,
        isLoggedIn: true,
      );
      print("✅ User data saved locally.");
      print("Navigating to the home page...");
      Get.snackbar(
          "success".tr,
          "login".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      Get.offAllNamed('/map');
    } catch (e) {
      print("❌ Login Error: $e");
      Get.snackbar(
        "Login Error".tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void resetErrors() {
    emailError.value = '';
    passwordError.value = '';
    print("Errors reset.");
  }
}
