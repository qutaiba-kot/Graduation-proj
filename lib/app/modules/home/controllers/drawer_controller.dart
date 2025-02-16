import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/user_info.dart';

class MyDrawerController extends GetxController { 
  final GetStorage storage = GetStorage();

  void logout() async {
  try {
    final UserStorageService userStorage = UserStorageService();

    if (userStorage.isLoggedIn) {
      userStorage.clearUserData();

      if (!userStorage.isLoggedIn) {
        print("User logged out successfully.");
        Get.offAllNamed('/login'); 
      } else {
        print("Failed to log out. Data still exists.");
      }
    } else {
      print("User is already logged out.");
    }
  } catch (e) {
    print("An error occurred during logout: $e");
  }
}
@override
  void onClose() {
    super.onClose();
  }

}
