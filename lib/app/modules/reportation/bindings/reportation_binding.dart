import 'package:get/get.dart';
import 'package:maps/app/modules/reportation/controllers/reportation_controller.dart';

class ReportationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportationController());
  }
}
