import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends GetxController {
  final GetStorage storage = GetStorage();
  GoogleMapController? googleMapController;

  @override
  void onClose() {
    googleMapController?.dispose(); // التخلص من GoogleMapController بأمان
    super.onClose();
  }
}
