import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/user_info.dart';

class Submitcomplaint extends GetxController {
  // إرسال شكوى إلى Supabase
  Future<void> submitComplaint(int hazardTypeId) async {
    try {
      print("🚀 بدء عملية إرسال الشكوى...");

      // 1. Get current location
      print("📍 محاولة الحصول على الموقع الحالي...");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final double latitude = position.latitude;
      final double longitude = position.longitude;

      print("✅ Coordinates received: $latitude, $longitude");

      // 2. Insert location with explicit error handling
      print("📤 Inserting location...");
      final locationResult = await Supabase.instance.client
          .from('locations')
          .insert({
            'latitude': latitude,
            'longitude': longitude,
          })
          .select()
          .maybeSingle(); // Use maybeSingle() instead of select()

      if (locationResult == null) {
        throw Exception("Location insertion failed - no response received");
      }

      final locationId = locationResult['location_id'];
      if (locationId == null) {
        throw Exception("Location ID is null after insertion");
      }

      print("✅ Location inserted successfully with ID: $locationId");

      // 3. Insert report with the location
      print("📤 Inserting report...");
      final UserStorageService userStorage = UserStorageService();

      final reportResult = await Supabase.instance.client
          .from('reports')
          .insert({
            'hazard_type_id': hazardTypeId,
            'location_id': locationId,
            'user_id': userStorage.userId,
          })
          .select()
          .maybeSingle();

      if (reportResult == null) {
        throw Exception("Report insertion failed - no response received");
      }

      print("✅ Report inserted successfully");

      Get.snackbar(
        "success".tr,
        "Complaint sent successfully".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar(
        "Error".tr,
        "An error occurred while submitting the complaint:".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
