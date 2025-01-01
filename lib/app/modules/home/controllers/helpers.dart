import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Helpers {
  static List<LatLng> decodePolyline(String polyline) {
    if (polyline.isEmpty) {
      print("Polyline string is empty.");
      return [];
    }

    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  static double calculateDistanceToPolyline(
      double lat, double lng, List<LatLng> polylinePoints) {
    if (polylinePoints.isEmpty) {
      print("Polyline points are empty.");
      return double.infinity;
    }

    if (polylinePoints.length == 1) {
      return Geolocator.distanceBetween(
          lat, lng, polylinePoints[0].latitude, polylinePoints[0].longitude);
    }

    double minDistance = double.infinity;
    for (int i = 0; i < polylinePoints.length - 1; i++) {
      double distance = _pointToSegmentDistance(
        LatLng(lat, lng),
        polylinePoints[i],
        polylinePoints[i + 1],
      );
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
    return minDistance;
  }

  static double _pointToSegmentDistance(LatLng point, LatLng start, LatLng end) {
    double px = point.latitude;
    double py = point.longitude;

    double sx = start.latitude;
    double sy = start.longitude;

    double ex = end.latitude;
    double ey = end.longitude;

    double dx = ex - sx;
    double dy = ey - sy;

    if (dx == 0 && dy == 0) {
      return Geolocator.distanceBetween(px, py, sx, sy);
    }

    double t = ((px - sx) * dx + (py - sy) * dy) / (dx * dx + dy * dy);
    t = max(0, min(1, t));

    double projX = sx + t * dx;
    double projY = sy + t * dy;

    return Geolocator.distanceBetween(px, py, projX, projY);
  }

  static LatLngBounds calculateLatLngBounds(Set<Marker> markers) {
    if (markers.isEmpty) {
      throw Exception("Markers set is empty.");
    }

    double south = markers.first.position.latitude;
    double north = markers.first.position.latitude;
    double west = markers.first.position.longitude;
    double east = markers.first.position.longitude;

    for (var marker in markers) {
      if (marker.position.latitude > north) north = marker.position.latitude;
      if (marker.position.latitude < south) south = marker.position.latitude;
      if (marker.position.longitude > east) east = marker.position.longitude;
      if (marker.position.longitude < west) west = marker.position.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }
}
