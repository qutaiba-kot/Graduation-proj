import 'package:get/get.dart';

import '../controllers/drawer_controller.dart';

class MyDrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyDrawerController>(() => MyDrawerController());
  }
}
