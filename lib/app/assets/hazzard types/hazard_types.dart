import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HazardType {
  final int hazardTypeId;
  final String name;
  final IconData icon; // حقل جديد للأيقونات

  HazardType({required this.hazardTypeId, required this.name, required this.icon});

  // Factory method لتحويل Map إلى كائن Dart
  factory HazardType.fromMap(Map<String, dynamic> map) {
    return HazardType(
      hazardTypeId: map['hazard_type_id'],
      name: map['name'],
      icon: map['icon'], // افترض وجود الحقل في البيانات
    );
  }

  // لتحويل كائن Dart إلى Map
  Map<String, dynamic> toMap() {
    return {
      'hazard_type_id': hazardTypeId,
      'name': name,
      'icon': icon, // حفظ الأيقونة
    };
  }
}

class HazardTypeService {
  // قائمة البيانات مع الأيقونات
  static final List<HazardType> hazardTypes = [
    HazardType(hazardTypeId: 1, name: "Speed Bump".tr, icon: Icons.speed),
    HazardType(hazardTypeId: 2, name: "Speed Camera".tr, icon: Icons.camera_alt),
    HazardType(hazardTypeId: 3, name: "Police Checkpoint".tr, icon: Icons.local_police),
    HazardType(hazardTypeId: 4, name: "Road Damage".tr, icon: Icons.construction),
    HazardType(hazardTypeId: 5, name: "Construction".tr, icon: Icons.build),
  ];

  // إرجاع القائمة
  static List<HazardType> getHazardTypes() {
    return hazardTypes;
  }

  // الحصول على عنصر واحد حسب ID
  static HazardType? getHazardTypeById(int id) {
    return hazardTypes.firstWhere(
      (hazard) => hazard.hazardTypeId == id,
      orElse: () => HazardType(
        hazardTypeId: 0,
        name: "Not Found",
        icon: Icons.error,
      ),
    );
  }
}
