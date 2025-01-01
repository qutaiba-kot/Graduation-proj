import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../assets/hazzard types/hazard_types.dart';

class RecallTags extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final markers = <Marker>{}.obs; 
  final List<LatLng> markerCoordinates = []; 
  Future<BitmapDescriptor> getBitmapDescriptorFromIconData(
      IconData iconData, Color backgroundColor, Color iconColor) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 150; 

    final paint = Paint()..color = backgroundColor;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size / 2,
        fontFamily: iconData.fontFamily,
        color: iconColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(buffer);
  }

  Future<void> fetchAndDisplayHazards(BuildContext context) async {
    try {
      print("🚀 [START] Fetching hazards data from 'hazards' table...");

      final hazardsResponse = await _client
          .from('hazards')
          .select('location_id, hazard_type_id');

      print("✅ [SUCCESS] Hazards fetched: ${hazardsResponse.length} entries found.");

      if (hazardsResponse == false || hazardsResponse.isEmpty) {
        print("⚠️ [WARNING] No hazards found.");
        return;
      }

      final List hazards = hazardsResponse;
      print("🛠️ [DEBUG] Hazards: $hazards");

      final locationIds = hazards.map((hazard) => hazard['location_id']).toList();
      print("🛠️ [DEBUG] Extracted location IDs: $locationIds");

      final locationsResponse = await _client
          .from('locations')
          .select('location_id, latitude, longitude')
          .filter('location_id', 'in', locationIds);
        

      print("✅ [SUCCESS] Locations fetched: ${locationsResponse.length} entries found.");

      if (locationsResponse == false || locationsResponse.isEmpty) {
        print("⚠️ [WARNING] No matching locations found.");
        return;
      }

      final List locations = locationsResponse;
      print("🛠️ [DEBUG] Locations: $locations");

      print("🚀 [START] Creating markers...");
      for (var hazard in hazards) {
        print("🔍 [PROCESSING] Hazard: $hazard");

        final matchingLocations = locations.where(
          (loc) => loc['location_id'] == hazard['location_id'],
        );

        if (matchingLocations.isNotEmpty) {
          final location = matchingLocations.first;
          print("✅ [MATCH FOUND] Location for hazard ID ${hazard['location_id']} found: $location");

          final hazardType = HazardTypeService.getHazardTypeById(hazard['hazard_type_id']);

          if (hazardType != null) {
            final backgroundColor = Theme.of(context).colorScheme.background;
            final iconColor = Theme.of(context).colorScheme.onBackground;

            final customIcon = await getBitmapDescriptorFromIconData(
              hazardType.icon,
              backgroundColor,
              iconColor,
            );

            final marker = Marker(
              markerId: MarkerId('marker_${hazard['location_id']}'),
              position: LatLng(location['latitude'], location['longitude']),
              icon: customIcon,
              infoWindow: InfoWindow(
                title: hazardType.name,
                snippet: 'Location ID: ${hazard['location_id']}',
              ),
            );
            markers.add(marker);
            
            markerCoordinates.add(LatLng(location['latitude'], location['longitude']));

            print("✅ [MARKER ADDED] Marker for Location ID ${hazard['location_id']} added.");
          } else {
            print("⚠️ [WARNING] No matching hazard type found for ID ${hazard['hazard_type_id']}.");
          }
        } else {
          print("⚠️ [WARNING] No matching location found for hazard ID ${hazard['location_id']}.");
        }
      }

      markers.refresh();
      print("✅ [COMPLETE] Markers added successfully: ${markers.length} markers in total.");
    } catch (e) {
      print("❌ [ERROR] An error occurred: $e");
    }
  }
}
