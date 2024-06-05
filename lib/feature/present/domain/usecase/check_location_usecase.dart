import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CheckCorrectLocationUsecase {
  final geoJson = GeoJson();

  Future<void> loadGeoJson() async {
    final geoJsonAssets = await rootBundle.loadString(
      'assets/location/location.json',
    );
    await geoJson.parse(geoJsonAssets);
  }

  Future<bool> checkLocationStatus(LatLng latLng) async {
    await loadGeoJson();

    final feature = geoJson.features;
    if (feature.isEmpty) {
      return false;
    }

    final line = feature.first.geometry as GeoJsonLine;
    final coordinates = line.geoSerie!.geoPoints
        .map(
          (e) => LatLng(e.latitude, e.longitude),
        )
        .toList();

    //Tolerances distance
    const toleranceDistance = 50;
    for (var i = 0; i < coordinates.length; i++) {
      final distance = Geolocator.distanceBetween(
        latLng.latitude,
        latLng.longitude,
        coordinates[i].latitude,
        coordinates[i].longitude,
      );

      log("Ini distance: $distance");
      if (distance <= toleranceDistance) {
        return true;
      }
    }
    for (var i = 0; i < coordinates.length - 1; i++) {
      final segmentDistance = distanceToSegment(
        latLng,
        coordinates[i],
        coordinates[i + 1],
      );

      log("Ini segment distance: $segmentDistance");
      if (segmentDistance <= toleranceDistance) {
        return true;
      }
    }
    return false;
  }

  double distanceToSegment(
    LatLng point,
    LatLng start,
    LatLng end,
  ) {
    final x0 = point.latitude;
    final y0 = point.longitude;
    final x1 = start.latitude;
    final y1 = start.longitude;
    final x2 = end.latitude;
    final y2 = end.longitude;

    final dx = x2 - x1;
    final dy = y2 - y1;
    final d2 = dx * dx + dy * dy;
    final nx = x0 - x1;
    final ny = y0 - y1;
    final t = (nx * dx + ny * dy) / d2;

    final closestX = x1 + t * dx;
    final closestY = y1 + t * dy;

    return Geolocator.distanceBetween(x0, y0, closestX, closestY);
  }
}
