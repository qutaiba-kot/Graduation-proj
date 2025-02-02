import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/data/user_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class ArchiveController extends GetxController {
  var photoUrlsMap = <String, List<String>>{}.obs;
  var locationCoordinates = <String, Map<String, double>>{}.obs;
  var complaints = <Map<String, dynamic>>[].obs;
  final storage = UserStorageService();
  @override
  void onInit() {
    super.onInit();
    fetchUserComplaints();

  }
  String statusCheck(String status) {
    if (status == "rejected") {
      return "rejected".tr;
    } else if (status == "validated") {
      return "validated".tr;
    } else {
      return "pending".tr;
    }
  }
  String reportType(String text) {
    if (text == "No Description") {
      return "Quick Report".tr;
    } else {
      return "Detailed Report".tr;
    }
  }
  Color makeColor(String status) {
    if (status.tr == "rejected") {
      return Colors.red;
    } else if (status.tr == "validated") {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  // جلب بيانات الموقع باستخدام location_id
  Future<void> fetchLocationById(String locationId) async {
    if (locationCoordinates.containsKey(locationId)) return;

    try {
      debugPrint(
          '[fetchLocationById] تحميل الإحداثيات لـ location_id: $locationId');

      final response = await Supabase.instance.client
          .from('locations')
          .select('latitude, longitude')
          .eq('location_id', locationId)
          .single();

      // ignore: unnecessary_null_comparison
      if (response != null) {
        locationCoordinates[locationId] = {
          'latitude': response['latitude'],
          'longitude': response['longitude'],
        };
      } else {
        debugPrint(
            '⚠️ [fetchLocationById] لم يتم العثور على الموقع: $locationId');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [fetchLocationById] خطأ أثناء جلب الموقع: $e\n$stackTrace');
    }
  }

  // جلب صور التقرير باستخدام report_id
  Future<void> fetchPhotosByReportId(String reportId) async {
    if (photoUrlsMap.containsKey(reportId)) return;

    try {
      debugPrint('[fetchPhotosByReportId] تحميل الصور لـ report_id: $reportId');

      final response = await Supabase.instance.client
          .from('report_photos')
          .select('photo_url')
          .eq('report_id', reportId);

      photoUrlsMap[reportId] = response.isNotEmpty
          ? List<String>.from(response.map((e) => e['photo_url'].toString()))
          : [];

      debugPrint(
          '✅ [fetchPhotosByReportId] تم تحميل الصور لـ report_id: $reportId');
    } catch (e, stackTrace) {
      debugPrint(
          '❌ [fetchPhotosByReportId] خطأ أثناء جلب الصور: $e\n$stackTrace');
    }
  }

  // جلب الشكاوى الخاصة بالمستخدم
  Future<void> fetchUserComplaints() async {

    try {
      debugPrint('[fetchUserComplaints] بدأ تحميل بيانات الشكاوى');

      final uId = storage.userId;
      if (uId == null) {
        debugPrint(
            '⚠️ [fetchUserComplaints] رقم المستخدم غير موجود في التخزين المحلي.');
        return;
      }

      final response = await Supabase.instance.client
          .from('reports')
          .select('status, location_id, hazard_type_id, description, report_id')
          .eq('user_id', uId);

      complaints.value =
          response.isNotEmpty ? List<Map<String, dynamic>>.from(response) : [];

      for (var complaint in complaints) {
        final locationId = complaint['location_id']?.toString();
        if (locationId != null && locationId.isNotEmpty) {
          fetchLocationById(locationId);
        }
      }

      debugPrint(
          '✅ [fetchUserComplaints] تم تحميل الشكاوى بنجاح: ${complaints.length} شكوى');
    } catch (e, stackTrace) {
      debugPrint(
          '❌ [fetchUserComplaints] خطأ أثناء جلب الشكاوى: $e\n$stackTrace');
    }
  }
}
