import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Func {
  static String getTime() {
    final today = DateTime.now();
    final hour = today.hour.toString();
    final minute = today.minute.toString();
    return "$hour:$minute";
  }

  static Future<Position?> getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    final location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return location;
  }

  static num getDistance(LatLng masterLatLng, LatLng userLatLng) {
    var distance = const Distance();
    return distance(
      masterLatLng,
      userLatLng,
    );
  }

  static bool checkAttendance(num meter) {
    return meter < 50;
  }
}
