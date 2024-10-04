import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<OnMainInit>(_onInit);
    on<OnMainAddAttendanceManual>(_onMainAddAttendanceManual);
    on<OnMainAddAttendanceAuto>(_onMainAddAttendanceAuto);
  }

  Future<Position?> _getCurrentLocation() async {
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

  bool _checkAttendance(LatLng masterLatLng, LatLng userLatLng) {
    var distance = const Distance();
    final meter = distance(
      masterLatLng,
      userLatLng,
    );
    return meter < 50;
  }

  void _onInit(var event, var emit) async {
    emit(MainLoading());
    try {
      // -6.1707388,106.8107806
      final location = await _getCurrentLocation();
      if (location == null) {
        emit(const MainError(message: 'Permission denied'));
      }
      final cLat = location != null ? location.latitude : 0.0;
      final cLng = location != null ? location.longitude : 0.0;

      emit(MainLoaded(
        masterLatLng: LatLng(cLat, cLng),
      ));
    } catch (e) {
      emit(MainError(message: e.toString()));
    }
  }

  void _onMainAddAttendanceManual(
    OnMainAddAttendanceManual event,
    var emit,
  ) async {
    final state = this.state;
    if (state is MainLoaded) {
      final masterLatLng = state.copyWith().masterLatLng;
      if (masterLatLng == null) {
        return;
      }

      final isSuccess = _checkAttendance(masterLatLng, event.latLng);
      if (isSuccess) {
      } else {
        print("failed");
      }

      emit(state.copyWith(userLatLng: event.latLng));
    }
  }

  void _onMainAddAttendanceAuto(
    OnMainAddAttendanceAuto event,
    var emit,
  ) async {
    final state = this.state;
    if (state is MainLoaded) {
      final masterLatLng = state.copyWith().masterLatLng;
      if (masterLatLng == null) {
        return;
      }

      final location = await _getCurrentLocation();
      if (location == null) {
        return;
      }
      final cLat = location.latitude;
      final cLng = location.longitude;
      final latLng = LatLng(cLat, cLng);

      final isSuccess = _checkAttendance(masterLatLng, latLng);
      event.onCallback(isSuccess);
      if (isSuccess) {
      } else {
        print("failed");
      }

      emit(state.copyWith(userLatLng: latLng));
    }
  }
}
