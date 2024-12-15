import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/user_info.dart';
import '../../../global/ConfirmTrackingWidget.dart';
import 'constants.dart';
import 'helpers.dart';
import 'recall_tags.dart';

class MapController extends GetxController {
  GoogleMapController? _googleMapController;
  final storage = GetStorage();
  final Rx<Polyline> routePolyline = Polyline(
    polylineId: PolylineId("route"),
    color: Colors.blue,
    width: 5,
  ).obs;
  final Rx<LatLng?> selectedDestination = Rx<LatLng?>(null);
  final Rx<String> remainingDistance = ''.obs;
  final Rx<String> remainingDuration = ''.obs;
  final RxList<Map<String, dynamic>> searchSuggestions = <Map<String, dynamic>>[].obs;
  StreamSubscription<Position>? positionStream;
  final isDarkMode = false.obs;
  GoogleMapController? mapController;
  final RecallTags recallTags = Get.put(RecallTags());
  double currentZoom = 15.0;
  var isPositionedVisible = false.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<CameraPosition> currentPosition = CameraPosition(
    target: LatLng(31.963158, 35.930359), // الموقع الافتراضي: عمان
    zoom: 15,
  ).obs;
  @override
  void onInit() {
    super.onInit();
    print("🚀 App Initialized. Starting to fetch the initial position.");
    getInitialPosition(); // استدعاء الموقع الابتدائي عند بدء التطبيق
    // تحميل الوضع الحالي من التخزين المحلي
    isDarkMode.value = storage.read('isDarkMode') ?? false;
  }
  Future<void> getInitialPosition() async {
    try {
      print("🔍 Checking location service...");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("⚠️ خدمة الموقع غير مفعلة.");
      }

      print("🔍 Checking location permissions...");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print("⚠️ Location permission is denied. Requesting permission...");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("⛔ إذن الموقع مرفوض.");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            "⛔ إذن الموقع مرفوض بشكل دائم. لا يمكن طلب الإذن مجددًا.");
      }

      print("📍 Fetching current position...");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18,
      );
      print(
          "✅ Current position fetched: ${position.latitude}, ${position.longitude}");

      updateCameraPosition(); // تحديث الكاميرا بعد تعيين الموقع
    } catch (e) {
      print("❌ Error occurred while fetching location: $e");
      currentPosition.value = CameraPosition(
        target: LatLng(31.963158, 35.930359), // عمان
        zoom: 15,
      );
      print("ℹ️ Default position (Amman) is set.");
    }
  }


  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print("✅ MapController is now assigned.");
    // استدعاء تحديث الموقع بعد تعيين الـ controller
    updateCameraPosition();
  }
  void setMapController(GoogleMapController controller) {
    print("🗺️ [INFO] Setting GoogleMapController...");
    _googleMapController = controller;
    loadAndApplyMapStyle();
  }
  Future<void> loadAndApplyMapStyle() async {
    if (_googleMapController == null) {
      print(
          "⚠️ [WARNING] GoogleMapController is not initialized yet. Skipping style application.");
      return;
    }

    print("🎨 [INFO] Loading and applying map style...");
    try {
      final mapStyles = await loadMapStyles();
      print("📄 [SUCCESS] Map styles loaded successfully.");

      final mapStyle = getMapStyle(mapStyles, isDarkMode.value);
      print(
          "🎭 [INFO] Applying map style: ${isDarkMode.value ? "Night" : "Day"} mode.");

      _googleMapController!.setMapStyle(mapStyle);
      print("✅ [SUCCESS] Map style applied successfully.");
    } catch (e) {
      print("❌ [ERROR] Failed to apply map style: $e");
    }
  }
  Future<Map<String, dynamic>> loadMapStyles() async {
    print("📂 [INFO] Loading map styles from JSON file...");
    try {
      final String jsonString = await rootBundle
          .loadString('lib/app/assets/map_design/map_style.json');
      print("📄 [SUCCESS] Map styles JSON loaded.");
      return json.decode(jsonString);
    } catch (e) {
      print("❌ [ERROR] Failed to load map styles JSON: $e");
      return {};
    }
  }
  String getMapStyle(Map<String, dynamic> mapStyles, bool isDarkMode) {
    print(
        "🎛️ [INFO] Selecting map style for ${isDarkMode ? "Night" : "Day"} mode.");
    return isDarkMode
        ? json.encode(mapStyles['night'])
        : json.encode(mapStyles['day']);
  }

  @override
  Future<void> fetchSearchSuggestions(String query) async {
    try {
      final url =
          "${AppConstants.placesBaseUrl}/autocomplete/json?input=$query&key=${AppConstants.googleApiKey}&components=country:${AppConstants.jordanCountryCode}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "OK") {
          searchSuggestions.value =
              List<Map<String, dynamic>>.from(data['predictions']);
        } else {
          print("❌ خطأ أثناء جلب الاقتراحات: ${data['error_message']}");
        }
      } else {
        print("❌ فشل الاتصال بـ Places API: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء جلب الاقتراحات: $e");
    }
  }
  void selectDestination(LatLng destination) {
    selectedDestination.value = destination;
    markers.add(Marker(
      markerId: MarkerId("destination"),
      position: destination,
      infoWindow: InfoWindow(title: "الوجهة المختارة"),
    ));
  }
  Future<void> fetchPlaceDetails(String placeId) async {
    try {
      final url =
          "${AppConstants.placesBaseUrl}/details/json?place_id=$placeId&key=${AppConstants.googleApiKey}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "OK") {
          final lat = data['result']['geometry']['location']['lat'];
          final lng = data['result']['geometry']['location']['lng'];
          final destination = LatLng(lat, lng);
          selectDestination(destination);
          mapController
              ?.animateCamera(CameraUpdate.newLatLngZoom(destination, 15));
        } else {
          print("❌ خطأ أثناء جلب تفاصيل المكان: ${data['error_message']}");
        }
      } else {
        print("❌ فشل الاتصال بـ Details API: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء جلب تفاصيل المكان: $e");
    }
  }
  void confirmStartTracking(String description) {
    // التحقق مما إذا كان هناك تتبع نشط
    if (positionStream != null) {
      Get.snackbar(
        "رحلة نشطة".tr,
        "الرجاء إنهاء الرحلة الحالية قبل بدء رحلة جديدة.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // عرض BottomSheet لتأكيد بدء التنقل
    Get.bottomSheet(
      ConfirmTrackingWidget(
        description: description, // تمرير الوصف
        onConfirm: () {
          startTracking(); // استدعاء وظيفة بدء التنقل
          Get.back(); // إغلاق BottomSheet
          togglePositionedVisibility(true);
        },
        onCancel: () {
          Get.back(); // إغلاق BottomSheet
        },
      ),
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
  Future<void> getDirections(LatLng start, LatLng destination) async {
    try {
      final url =
          "${AppConstants.directionsBaseUrl}?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=${AppConstants.googleApiKey}";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "OK") {
          final points = Helpers.decodePolyline(
              data['routes'][0]['overview_polyline']['points']);
          routePolyline.value = Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: points,
          );
          remainingDistance.value =
              data['routes'][0]['legs'][0]['distance']['text'];
          remainingDuration.value =
              data['routes'][0]['legs'][0]['duration']['text'];
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error".tr,
        "An error occurred while getting directions:$e".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void startTracking() {
    if (positionStream != null) {
      print("⚠️ Tracking is already active.");
      return;
    }
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // تحديث كل 10 أمتار
      ),
    ).listen((Position position) {
      updateRouteProgress(position); // تحديث المسافة والزمن المتبقي
      checkIfOffRoute(position); // التحقق إذا خرج المستخدم عن المسار
      updateCameraWithBearing(position); // تحديث الكاميرا
    });
    print("🚀 Tracking started.");
  }
  void updateRouteProgress(Position position) async {
    if (routePolyline.value.points.isEmpty ||
        selectedDestination.value == null) {
      return;
    }
    // الموقع الحالي للمستخدم
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    // إيجاد أقرب نقطة على المسار
    double minDistance = double.infinity;
    int closestIndex = 0;
    for (int i = 0; i < routePolyline.value.points.length; i++) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        routePolyline.value.points[i].latitude,
        routePolyline.value.points[i].longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    // تحديث المسافة المتبقية
    double totalRemainingDistance = 0;
    for (int i = closestIndex; i < routePolyline.value.points.length - 1; i++) {
      totalRemainingDistance += Geolocator.distanceBetween(
        routePolyline.value.points[i].latitude,
        routePolyline.value.points[i].longitude,
        routePolyline.value.points[i + 1].latitude,
        routePolyline.value.points[i + 1].longitude,
      );
    }
    remainingDistance.value =
        "${(totalRemainingDistance / 1000).toStringAsFixed(2)} km";
    // عرض رسالة عند الوصول
    if (totalRemainingDistance <= 5) {
      // إذا كانت المسافة أقل من 5 أمتار
      Get.snackbar(
        "Congratulations!".tr,
        "You have reached your destination.".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      stopNavigation(); // إيقاف التوجيه
    }
    // حساب الزمن المتبقي بناءً على السرعة
    double averageSpeed = 40.0; // سرعة المستخدم بالكيلومتر/ساعة
    double estimatedTime =
        totalRemainingDistance / (averageSpeed * 1000 / 3600);
    remainingDuration.value = "${estimatedTime.toStringAsFixed(1)} mins";
    // تحديث النقاط المتبقية على المسار
    List<LatLng> remainingPoints =
        routePolyline.value.points.sublist(closestIndex);
    routePolyline.value =
        routePolyline.value.copyWith(pointsParam: remainingPoints);
    // تحديث واجهة المستخدم
    routePolyline.refresh();
    remainingDistance.refresh();
    remainingDuration.refresh();
  }


  void updateCameraWithBearing(Position position) {
    final newCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 20,
      bearing: position.heading,
      tilt: 90,
    );
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    checkIfOffRoute(position);
  }
Future<void> updateCameraPosition() async {
    if (mapController == null) {
      print("⏳ Waiting for mapController to be assigned...");
      await Future.delayed(Duration(milliseconds: 500)); // انتظر 500 مللي ثانية
      updateCameraPosition(); // أعد استدعاء الوظيفة
      return;
    }

    print('📍 Updating camera position...');
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    mapController?.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: currentPosition.value.zoom,
      ),
    ));
    print("✅ Camera position updated successfully.");
  }
void checkIfOffRoute(Position position) async {
    double distanceToNearestPoint = Helpers.calculateDistanceToPolyline(
      position.latitude,
      position.longitude,
      routePolyline.value.points,
    );

    if (distanceToNearestPoint > 50) {
      // إذا كان خارج المسار بمسافة أكثر من 50 مترًا
      if (selectedDestination.value != null) {
        await getDirections(
          LatLng(position.latitude, position.longitude),
          selectedDestination.value!,
        );
      }
    }
  }
  void onCameraMove(CameraPosition position) {
    // تحديث موقع الكاميرا
    currentPosition.value = position;

    // تحقق من التحديث لتقليل الحمل
    if ((position.zoom - currentZoom).abs() >= 1.0) {
      // تحديث فقط عند اختلاف الزوم بشكل ملحوظ
      updateMarkersVisibility(position.zoom);
      currentZoom = position.zoom; // تخزين الزوم الحالي
    }
  }
  void updateMarkersVisibility(double zoomLevel) {
    if (zoomLevel >= 16) {
      // عرض جميع العلامات
      if (markers.length != recallTags.markers.length) {
        markers.assignAll(recallTags.markers); // فقط إذا كانت هناك حاجة للتحديث
      }
    } else {
      if (markers.isNotEmpty) {
        markers.clear(); // إخفاء العلامات فقط عند الحاجة
      }
    }
  }



  void stopTracking() {
    if (positionStream != null) {
      positionStream?.cancel(); // إلغاء الاشتراك في تدفق الموقع
      positionStream = null; // إعادة تعيين المتغير لتجنب التكرار
      print("🚫 Tracking stopped successfully.");
    } else {
      print("⚠️ No active tracking to stop.");
    }
  }
  void clearRoute() {
    // إعادة تعيين قيمة Polyline إلى قائمة فارغة
    routePolyline.value = Polyline(
      polylineId: PolylineId("route"), // نفس معرف Polyline
      color: Colors.transparent, // اجعل الخط شفافًا (اختياري)
      width: 0, // تعيين العرض إلى 0 لإخفاء الخط (اختياري)
      points: [], // إزالة جميع النقاط
    );
    // تحديث الواجهة لتنعكس التعديلات
    routePolyline.refresh();
    print("🗑️ Route cleared successfully.");
  }
  void cancelDestination() {
    if (selectedDestination.value != null) {
      selectedDestination.value = null;
      markers.removeWhere((marker) => marker.markerId.value == "destination");
      markers.refresh();
      // إعادة تعيين الكاميرا إلى الموقع الحالي
      updateCameraPosition(); // استدعاء دالة تحديث الكاميرا
      print("🚫 Destination canceled, marker removed, and camera reset.");
    } else {
      print("⚠️ No destination to cancel.");
    }
  }
  void stopNavigation() {
    stopTracking(); // إيقاف التتبع
    clearRoute(); // إزالة المسار
    cancelDestination(); // إلغاء الوجهة
    togglePositionedVisibility(false);
    print("🛑 Navigation stopped.");
  }
  void togglePositionedVisibility(bool isVisible) {
    isPositionedVisible.value = isVisible; // تحديث الحالة
  }
  void onClose() {
    stopTracking();
    super.onClose();
  }

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
