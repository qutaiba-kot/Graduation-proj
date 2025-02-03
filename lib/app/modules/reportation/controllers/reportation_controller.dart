import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../assets/hazzard types/hazard_types.dart';
import '../../../data/user_info.dart';

class ReportationController extends GetxController {
  final RxInt selectedProblemId = 0.obs;
  final TextEditingController descriptionController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _imagePicker = ImagePicker();
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        Get.snackbar(
          'Alert'.tr,
          'No image is chosen.'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An error occurred while choosing the image: $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Error'.tr,
            'Location access denied'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An error occurred while locating: $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  final List<HazardType> problemTypes = HazardTypeService.getHazardTypes();

  Future<void> submitComplaint() async {
  try {
    // عرض شاشة التحميل
    Get.dialog(
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
                'lib/app/assets/GIF/Animation - 1737898892819.gif'), // عرض GIF
            SizedBox(height: 16),
          ],
        ),
      ),
      barrierDismissible: false,
      barrierColor: Get.theme.colorScheme.background,
    );

    print("🚀 بدء عملية إرسال الشكوى...");

    // **التحقق من الحقول المطلوبة**
    if (selectedProblemId.value == 0) {
      throw Exception("Please select the type of the report".tr);
    }
    if (descriptionController.text.trim().isEmpty) {
      throw Exception("Please fill the description".tr);
    }
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      throw Exception("Please press the button to get your location".tr);
    }
    if (selectedImage.value == null) {
      throw Exception("Please insert a photo".tr);
    }

    print("📤 محاولة إدراج التقرير الأساسي...");
    final UserStorageService userStorage = UserStorageService();
    int locationId = await _insertLocation();
    print("📍 موقع إدراج الموقع ناجح، ID: $locationId");

    final reportResult = await Supabase.instance.client
        .from('reports')
        .insert({
          'hazard_type_id': selectedProblemId.value,
          'location_id': locationId,
          'user_id': userStorage.userId,
          'description': descriptionController.text,
        })
        .select()
        .maybeSingle();

    if (reportResult == null) {
      throw Exception("Report insertion failed - no response received.");
    }

    final int reportId = reportResult['report_id'];
    print("✅ Report inserted successfully with ID: $reportId");

    print("📤 محاولة رفع الصورة...");
    final String imageUrl = await _uploadImage(selectedImage.value!);
    print("🌐 Image uploaded successfully with URL: $imageUrl");

    print("📤 محاولة إدراج الصورة في جدول report_photos...");
    final photoResult = await Supabase.instance.client
        .from('report_photos')
        .insert({
          'photo_url': imageUrl,
          'report_id': reportId,
        })
        .select()
        .maybeSingle();

    if (photoResult == null) {
      throw Exception("Report photo insertion failed.");
    }

    print("✅ Photo linked to report successfully.");
    print("🎉 الشكوى أرسلت بنجاح.");

    // إغلاق شاشة التحميل بعد النجاح
    Get.back();
    Get.back();

    Get.snackbar(
      "success".tr,
      "Complaint sent successfully".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    print("♻️ إعادة تعيين الحقول...");
    resetForm();
    print("✅ تم إعادة تعيين الحقول بنجاح.");
  } catch (e) {
    print("❌ Error during complaint submission: $e");

    // إغلاق شاشة التحميل عند حدوث خطأ
    Get.back();

    Get.snackbar(
      "Error".tr,
      "$e".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


  Future<int> _insertLocation() async {
    print("📍 محاولة إدراج الموقع...");
    try {
      final locationResult = await Supabase.instance.client
          .from('locations')
          .insert({
            'latitude': latitude.value,
            'longitude': longitude.value,
          })
          .select()
          .maybeSingle();

      if (locationResult == null) {
        throw Exception("Location insertion failed - no response received.");
      }

      final int locationId = locationResult['location_id'];
      print("✅ Location inserted successfully with ID: $locationId");
      return locationId;
    } catch (e) {
      throw Exception("❌ خطأ أثناء إدراج الموقع: $e");
    }
  }

  Future<String> _uploadImage(File image) async {
    print("📤 بدء رفع الصورة إلى Storage...");
    try {
      final String imageName =
          "reports/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}";

      final imageBytes = await image.readAsBytes();
      await Supabase.instance.client.storage.from('report-photos').uploadBinary(
            imageName,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );
      final String publicUrl = Supabase.instance.client.storage
          .from('report-photos')
          .getPublicUrl(imageName);

      return publicUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  void resetForm() {
    selectedProblemId.value = 0;
    descriptionController.clear();
    selectedImage.value = null;
    latitude.value = 0.0;
    longitude.value = 0.0;
  }
}
