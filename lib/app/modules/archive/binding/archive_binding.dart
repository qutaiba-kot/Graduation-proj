import 'package:get/get.dart';
import '../controller/archive_controller.dart';

class ArchiveBinding extends Bindings {
  @override
  void dependencies() {
    // تسجيل EmptyPageController عند استدعاء الصفحة
    Get.lazyPut<ArchiveController>(() => ArchiveController());
  }
}
