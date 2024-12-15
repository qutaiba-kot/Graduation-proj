import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/user_info.dart';
import '../../../routes/app_pages.dart';

class SignUpController extends GetxController {
  RxString nameError = ''.obs;
  RxString emailError = ''.obs;
  RxString phoneError = ''.obs;
  RxString passwordError = ''.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  final UserStorageService userStorageService = UserStorageService();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    print("Password visibility toggled: ${isPasswordVisible.value}");
  }

  bool validateName(String name) {
    print("Validating name: $name");
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      nameError.value = "Name must contain only letters and spaces.";
      print("Name validation failed: ${nameError.value}");
      return false;
    }
    nameError.value = '';
    print("Name validation passed.");
    return true;
  }

  bool validateEmail(String email) {
    print("Validating email: $email");
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      emailError.value = "Invalid email format.";
      print("Email validation failed: ${emailError.value}");
      return false;
    }
    emailError.value = '';
    print("Email validation passed.");
    return true;
  }

  bool validatePhone(String phone) {
    print("Validating phone: $phone");
    if (!phone.startsWith("+962") ||
        !RegExp(r'^\+962[0-9]{9}$').hasMatch(phone)) {
      phoneError.value = "Phone must start with +962 and contain 9 digits.";
      print("Phone validation failed: ${phoneError.value}");
      return false;
    }
    phoneError.value = '';
    print("Phone validation passed.");
    return true;
  }

  bool validatePassword(String password) {
    print("Validating password...");
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

  bool validateForm(String name, String email, String phone, String password) {
    print("Validating form...");
    final isNameValid = validateName(name);
    final isEmailValid = validateEmail(email);
    final isPhoneValid = validatePhone(phone);
    final isPasswordValid = validatePassword(password);

    if (isNameValid && isEmailValid && isPhoneValid && isPasswordValid) {
      print("Form validation passed.");
      return true;
    } else {
      print("Form validation failed.");
      return false;
    }
  }

  void signUp(String name, String email, String phone, String password) async {
    print("Sign-up initiated...");
    isLoading.value = true;

    try {
      // إرسال البيانات إلى Supabase
      print("Sending user data to Supabase...");
      final response = await Supabase.instance.client
          .from('users')
          .insert({
            'email': email,
            'password_hash': password, // كلمة المرور غير مشفرة
            'name': name,
            'phone': phone,
            'trusted_score': 100, // يمكن تخصيص هذه القيم
            'total_reports': 0,
          })
          .select()
          .maybeSingle();

      // التحقق من الاستجابة
      if (response != null) {
        print("User successfully registered. Response: $response");
        Get.snackbar(
          "success".tr,
          "signup".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // حفظ البيانات باستخدام UserStorageService
        print("Saving user data locally...");
        userStorageService.saveUserData(
          email: response['email'],
          phone: response['phone'],
          name: response['name'],
          userId: response['id'],
          trustedScore: response['trusted_score'],
          totalReports: response['total_reports'],
          isLoggedIn: true,
        );
        print("User data saved locally.");

        // الانتقال إلى الصفحة الرئيسية
        print("Navigating to the home page...");
        Get.offAllNamed(Routes.MAP);
      } else {
        throw Exception("Unexpected error occurred during sign-up.");
      }
    } catch (e) {
      // تتبع الأخطاء
      print("Error occurred during sign-up: ${e.toString()}");
      Get.snackbar(
        "Sign Up Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // تتبع نهاية العملية
      print("Sign-up process completed.");
      isLoading.value = false;
    }
  }
}
