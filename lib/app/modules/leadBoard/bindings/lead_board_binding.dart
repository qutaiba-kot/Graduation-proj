import 'package:get/get.dart';

import '../controllers/lead_board_controller.dart';

class LeadBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadBoardController>(
      () => LeadBoardController(),
    );
  }
}
