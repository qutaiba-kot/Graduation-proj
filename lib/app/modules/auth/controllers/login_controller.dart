import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart'; // مكتبة التشفير
import '../../../data/user_info.dart';

class LoginController extends GetxController {
  // الحالة لإظهار/إخفاء النص في حقل الباسوورد
  RxBool isPasswordVisible = false.obs;

  // الأخطاء الخاصة بالإيميل والباسوورد
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  // حالة التحميل
  RxBool isLoading = false.obs;

  // التخزين المحلي باستخدام UserStorageService
  final UserStorageService userStorageService = UserStorageService();

  // التحقق من صيغة الإيميل
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

  // التحقق من شروط الباسوورد
  bool validatePassword(String password) {
    if (password.length < 8) {
      passwordError.value = "Password must be at least 8 characters.".tr;
      print("Validation Error: Password too short: $password");
      return false;
    }
    passwordError.value = '';
    return true;
  }

  // تنفيذ عملية تسجيل الدخول باستخدام Supabase
  void login(String email, String password) async {
    // التحقق من صحة الإدخال
    if (!validateEmail(email) || !validatePassword(password)) {
      Get.snackbar(
        "Login Failed".tr,
        "Please correct the errors and try again.".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // تعيين حالة التحميل إلى true
    isLoading.value = true;

    try {
      print("🚀 Starting login process...");
      print("📧 Email: $email");

      // استدعاء بيانات المستخدم بناءً على البريد الإلكتروني
      print("Fetching user data from Supabase...");
      final additionalData = await Supabase.instance.client
          .from('users')
          .select('id, email, name, phone, password_hash, trusted_score, total_reports')
          .eq('email', email)
          //.eq('password_hash' ,password )
          .single();

      print("Data fetched from Supabase: $additionalData");

      // التحقق من وجود بيانات المستخدم
      if (additionalData == null || additionalData.isEmpty) {
        print("❌ No user found with the provided email.");
        throw Exception("Invalid email or password.");
      }

      // التحقق من صحة كلمة المرور المشفرة
    /*  final hashedPassword = additionalData['password_hash'];
      print("🔒 Checking password...");
      if (hashedPassword == null || !BCrypt.checkpw(password, hashedPassword)) {
        print("❌ Invalid password.");
        throw Exception("Invalid email or password.");
      }
      print("✅ Password is correct.");*/

      // استخراج البيانات من الاستعلام
      final userId = additionalData['id'] ?? 'Unknown';
      final userEmail = additionalData['email'] ?? 'Unknown';
      final name = additionalData['name'] ?? 'Unknown';
      final phone = additionalData['phone'] ?? 'Unknown';
      final trustedScore = additionalData['trusted_score'] ?? 0;
      final totalReports = additionalData['total_reports'] ?? 0;

      print(
          "Parsed Data -> UserID: $userId, Email: $userEmail, Name: $name, Phone: $phone, Trusted Score: $trustedScore, Total Reports: $totalReports");

      // تخزين البيانات محليًا
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

      // الانتقال إلى الصفحة الرئيسية
      print("Navigating to the home page...");
      Get.offAllNamed('/home');
    } catch (e) {
      // التعامل مع الأخطاء
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

  // التبديل بين إظهار وإخفاء الباسوورد
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // إعادة تعيين الأخطاء عند تغيير النص
  void resetErrors() {
    emailError.value = '';
    passwordError.value = '';
    print("Errors reset.");
  }
}
