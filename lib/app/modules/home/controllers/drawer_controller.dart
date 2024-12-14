import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/user_info.dart';

class MyDrawerController extends GetxController { // تغيير الاسم هنا
  final GetStorage storage = GetStorage();

  void logout() async {
  try {
    // استخدام UserStorageService لإدارة البيانات
    final UserStorageService userStorage = UserStorageService();

    if (userStorage.isLoggedIn) {
      // إزالة جميع بيانات المستخدم
      userStorage.clearUserData();

      // التحقق من حالة تسجيل الخروج
      if (!userStorage.isLoggedIn) {
        print("User logged out successfully.");
        Get.offAllNamed('/login'); // التنقل إلى صفحة تسجيل الدخول
      } else {
        print("Failed to log out. Data still exists.");
      }
    } else {
      print("User is already logged out.");
    }
  } catch (e) {
    // التعامل مع الأخطاء
    print("An error occurred during logout: $e");
  }
}

}
