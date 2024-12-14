import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../assets/hazzard types/hazard_types.dart';
import '../../../data/user_info.dart';

class ReportationController extends GetxController {
  // نوع المشكلة (ID للمشكلة)
  final RxInt selectedProblemId = 0.obs;

  // الوصف النصي
  final TextEditingController descriptionController = TextEditingController();

  // الصورة المرفقة
  final Rx<File?> selectedImage = Rx<File?>(null);

  // مكتبة اختيار الصور
  final ImagePicker _imagePicker = ImagePicker();

  // الإحداثيات
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // اختيار الصورة من الكاميرا أو المعرض
  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
        Get.snackbar(
          'success'.tr,
          'The image was successfully selected!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
        'An error occurred while choosing the image:. $e'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // الحصول على الموقع الحالي
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

      Get.snackbar(
        'success'.tr,
        'The current location has been successfully determined!'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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

  // قائمة أنواع المشاكل (تم تحميلها من HazardTypeService)
  final List<HazardType> problemTypes = HazardTypeService.getHazardTypes();

  // إرسال الشكوى
  Future<void> submitComplaint() async {
    try {
      print("🚀 بدء عملية إرسال الشكوى...");
      // التحقق من صحة المدخلات
      if (selectedProblemId.value == 0) {
        print("❌ خطأ: لم يتم اختيار نوع المشكلة.");
        throw Exception("يرجى اختيار نوع المشكلة.");
      }
      if (latitude.value == 0.0 || longitude.value == 0.0) {
        print("❌ خطأ: لم يتم تحديد الموقع.");
        throw Exception("يرجى تحديد الموقع الحالي.");
      }

      // 1. إدراج التقرير الأساسي في جدول reports
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
        print("❌ خطأ: إدخال التقرير فشل، لم يتم استلام استجابة.");
        throw Exception("Report insertion failed - no response received.");
      }

      final int reportId = reportResult['report_id'];
      print("✅ Report inserted successfully with ID: $reportId");

      // 2. رفع الصورة وربطها بالتقرير في جدول report_photos
      if (selectedImage.value != null) {
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
          print("❌ خطأ: إدراج الصورة في جدول report_photos فشل.");
          throw Exception(
              "Report photo insertion failed - no response received.");
        }

        print("✅ Photo linked to report successfully.");
      } else {
        print("⚠️ لم يتم اختيار صورة، تخطي خطوة رفع الصورة.");
      }

      // عرض رسالة نجاح
      print("🎉 الشكوى أرسلت بنجاح.");
      Get.snackbar(
        "success".tr,
        "Complaint sent successfully".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // إعادة تعيين الحقول
      print("♻️ إعادة تعيين الحقول...");
      resetForm();
      print("✅ تم إعادة تعيين الحقول بنجاح.");
    } catch (e, stackTrace) {
      // تتبع الخطأ وعرض رسالة خطأ للمستخدم
      print("❌ Error during complaint submission: $e");
      print("📚 Stack trace: $stackTrace");
      Get.snackbar(
        "Error".tr,
        "An error occurred while submitting the complaint:".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // إدخال الموقع في جدول locations
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
        print("❌ خطأ: إدراج الموقع فشل، لم يتم استلام استجابة.");
        throw Exception("Location insertion failed - no response received.");
      }

      final int locationId = locationResult['location_id'];
      print("✅ Location inserted successfully with ID: $locationId");
      return locationId;
    } catch (e) {
      print("❌ خطأ أثناء إدراج الموقع: $e");
      rethrow;
    }
  }

  // رفع الصورة إلى Supabase Storage
  Future<String> _uploadImage(File image) async {
    print("📤 بدء رفع الصورة إلى Storage...");
    try {
      // Create a unique filename using timestamp
      final String imageName =
          "reports/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}";
      print("📁 اسم الصورة: $imageName");

      final imageBytes = await image.readAsBytes();
      print("🔍 حجم الصورة بالبايت: ${imageBytes.length}");

      // Attempt upload
      await Supabase.instance.client.storage.from('report-photos').uploadBinary(
            imageName,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg', // Adjust based on your image type
              upsert: false,
            ),
          );

      // Get the public URL
      final String publicUrl = Supabase.instance.client.storage
          .from('report-photos')
          .getPublicUrl(imageName);
      print("🌐 Public URL for image: $publicUrl");

      return publicUrl;
    } catch (e) {
      print("❌ خطأ أثناء رفع الصورة: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  // إعادة تعيين البيانات بعد إرسال الشكوى
  void resetForm() {
    selectedProblemId.value = 0;
    descriptionController.clear();
    selectedImage.value = null;
    latitude.value = 0.0;
    longitude.value = 0.0;
  }
}
