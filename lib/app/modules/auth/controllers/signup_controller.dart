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
      nameError.value = "Name must contain only letters and spaces.".tr;
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
      emailError.value = "Invalid email format.".tr;
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
      phoneError.value = "Phone must start with +962 and contain 9 digits.".tr;
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
          "Password must be at least 8 characters long, contain uppercase letters, numbers, and special characters.".tr;
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
    print("Sign-up process started...");
    isLoading.value = true;

    try {
      // Step 1: Register user in Supabase Authentication
      print("Sending email and password to Supabase authentication...");
      print("Email: $email, Password: $password");
      final signUpResponse = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final uuid = signUpResponse.user?.id;
      if (uuid == null) {
        throw Exception("Failed to retrieve user ID (UUID) from sign-up response.");
      }
      print("User registered successfully with UUID: $uuid");

      // Step 2: Insert user data into 'users' table
      print("Inserting user data into 'users' table...");
      final userResponse = await Supabase.instance.client
          .from('users')
          .insert({
            'auth_id': uuid,
            'name': name,
            'email': email,
            'phone': phone,
          })
          .select()
          .maybeSingle();

      if (userResponse != null) {
        print("User data inserted successfully. Response: $userResponse");

        // Save user data locally
        print("Saving user data locally...");
        userStorageService.saveUserData(
          email: userResponse['email'],
          phone: userResponse['phone'],
          name: userResponse['name'],
          userId: userResponse['id'],
          trustedScore: userResponse['trusted_score'],
          totalReports: userResponse['total_reports'],
          isLoggedIn: true,
        );
        print("User data saved locally.");

        // Navigate to the home page
        print("Navigating to the home page...");
        Get.offAllNamed(Routes.MAP);
      } else {
        throw Exception("Unexpected error occurred while inserting user data into 'users' table.");
      }
    } catch (e) {
      print("Error occurred during sign-up: ${e.toString()}");
      Get.snackbar(
        "Error".tr,
        e.toString().tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      print("Sign-up process completed.");
      isLoading.value = false;
    }
  }
}
