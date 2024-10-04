import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class Func {
  static String today() {
    final today = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(today);
  }

  static String getTime({String? date}) {
    final now = date ?? today();
    final dateNow = DateFormat("yyyy-MM-dd HH:mm:ss").parse(now);
    return DateFormat("HH:mm").format(dateNow);
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
