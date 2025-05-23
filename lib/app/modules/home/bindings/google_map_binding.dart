import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/pip_controller.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/google_map_controller.dart';
import '../controllers/recall_tags.dart';

class GoogleMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController());
    Get.lazyPut<RecallTags>(() => RecallTags());
    Get.lazyPut<MyDrawerController>(() => MyDrawerController());
    Get.lazyPut<PipController>(() => PipController());
  }
}
