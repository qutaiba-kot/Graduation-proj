import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/google_map_controller.dart';
import 'package:maps/app/modules/home/views/google_map.dart';
import 'package:maps/app/modules/home/views/home_drawer.dart';
//import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  //final HomeController controller = Get.find();
  final MapController controlle = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          GoogleMapView(),      
    );
  }
}
