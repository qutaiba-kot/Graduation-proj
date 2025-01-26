
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/data/user_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArchiveController extends GetxController {
  // قائمة لتخزين بيانات الشكاوى
  var complaints = <Map<String, dynamic>>[].obs;

  // GetStorage لتخزين واسترجاع البيانات محليًا
  final storage = UserStorageService();

  @override
  void onInit() {
    super.onInit();
    fetchUserComplaints();
  }

  // وظيفة لجلب الشكاوى الخاصة بالمستخدم
    Future<void> fetchUserComplaints() async {
    try {
      // عرض نافذة التحميل بعد اكتمال البناء
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                    'lib/app/assets/GIF/Animation - 1737898892819.gif'), // عرض GIF من الأصول
                SizedBox(height: 16),
              ],
            ),
          ),
          barrierDismissible: false,
          barrierColor: Get.theme.colorScheme.background,
        );
      });

      // استرجاع رقم المستخدم من التخزين المحلي
      final uId = storage.userId;
      print("The user ID is = $uId");

      if (uId == null) {
        print('رقم المستخدم غير موجود في التخزين المحلي.');
        if (Get.isDialogOpen!) Get.back(); // إغلاق نافذة التحميل
        return;
      }

      // الاتصال بجدول reports في Supabase
      final response = await Supabase.instance.client
          .from('reports')
          .select('status, location_id, hazard_type_id') // جلب الحقول المطلوبة
          .eq('user_id', uId) // فلترة حسب رقم المستخدم
          .then((value) => value); // معالجة النتيجة مباشرة

      if (response.isEmpty) {
        print('لم يتم العثور على بيانات.');
        if (Get.isDialogOpen!) Get.back(); // إغلاق نافذة التحميل
        return;
      }

      // تحديث قائمة الشكاوى
      complaints.value = List<Map<String, dynamic>>.from(response);
      print('تم جلب البيانات بنجاح: ${complaints.value}');
    } catch (e) {
      print('حدث خطأ أثناء جلب الشكاوى: $e');
    } finally {
      // إغلاق نافذة التحميل في جميع الأحوال
      if (Get.isDialogOpen!) Get.back();
    }
  }

}