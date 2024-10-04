import 'package:attendanceapp/helper/func.dart';
import 'package:attendanceapp/model/master.dart';
import 'package:attendanceapp/storage/init.dart';
import 'package:attendanceapp/storage/models/attendance.dart';
import 'package:attendanceapp/storage/pref.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<OnMainInit>(_onInit);
    on<OnMainAddAttendanceManual>(_onMainAddAttendanceManual);
    on<OnMainAddAttendanceAuto>(_onMainAddAttendanceAuto);
    on<OnMainToggleMap>(_onMainToggleMap);
    on<OnMainResetAttendance>(_onMainResetAttendance);
    on<OnMainChangeMaster>(_onMainChangeMaster);
    on<OnMainOpenHistory>(_onMainOpenHistory);
  }

  void _onInit(var event, var emit) async {
    emit(MainLoading());
    try {
      var id = await Pref().get(PrefKey.id);
      if (id == -1) {
        await Pref().set(PrefKey.id, 0);
      }

      var indexMaster = 0;
      final masterData = [
        Master(
          name: "Kampus UNEJ",
          latLng: const LatLng(-8.1651576, 113.7138381),
        ),
        Master(
          name: "Kampus UM",
          latLng: const LatLng(-7.9605943, 112.6151022),
        ),
        Master(
          name: "Kampus IPB",
          latLng: const LatLng(-6.5539484, 106.7207479),
        ),
        Master(
          name: "Kampus ITS",
          latLng: const LatLng(-7.282356, 112.7923504),
        ),
      ];

      final mapController = MapController();

      emit(MainLoaded(
        indexMaster: indexMaster,
        masterLatLng: masterData[indexMaster].latLng,
        masterLatLngs: masterData,
        mapController: mapController,
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
      final latLng = event.latLng;

      final meter = Func.getDistance(masterLatLng, latLng);
      final isSuccess = Func.checkAttendance(meter);
      event.onCallback(isSuccess, meter);
      if (isSuccess) {
        final today = Func.today();
        final time = Func.getTime(date: today);
        var inTime = state.copyWith().inTime;
        var outTime = state.copyWith().outTime;
        if (inTime == null) {
          inTime = time;
        } else {
          outTime = time;
        }

        final attendance = state.copyWith().attendance;
        Attendance? cAttendance;
        if (attendance != null) {
          cAttendance = Attendance(
            id: attendance.id,
            name: attendance.name,
            inTime: attendance.inTime,
            outTime: outTime ?? "",
            createdAt: attendance.createdAt,
            updatedAt: today,
            success: outTime != null ? 1 : 0,
          );
          await LocalStorage().update(
            cAttendance,
          );
        } else {
          cAttendance = Attendance(
            id: await Pref().get(PrefKey.id),
            name: state.masterLatLngs[state.copyWith().indexMaster].name,
            inTime: inTime,
            outTime: outTime ?? "",
            createdAt: today,
            updatedAt: today,
            success: outTime != null ? 1 : 0,
          );
          final isInsert = await LocalStorage().insert(cAttendance);
          if (isInsert) {
            cAttendance = await LocalStorage().get(cAttendance.id);
          }
        }

        emit(
          state.copyWith(
            userLatLng: latLng,
            inTime: inTime,
            outTime: outTime,
            attendance: cAttendance,
          ),
        );
      }
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

      final location = await Func.getCurrentLocation();
      if (location == null) {
        return;
      }
      final cLat = location.latitude;
      final cLng = location.longitude;
      final latLng = LatLng(cLat, cLng);

      final meter = Func.getDistance(masterLatLng, latLng);
      final isSuccess = Func.checkAttendance(meter);
      event.onCallback(isSuccess, meter);
      if (isSuccess) {
        final today = Func.today();
        final time = Func.getTime(date: today);
        var inTime = state.copyWith().inTime;
        var outTime = state.copyWith().outTime;
        if (inTime == null) {
          inTime = time;
        } else {
          outTime = time;
        }

        final attendance = state.copyWith().attendance;
        Attendance? cAttendance;
        if (attendance != null) {
          cAttendance = Attendance(
            id: attendance.id,
            name: attendance.name,
            inTime: attendance.inTime,
            outTime: outTime ?? "",
            createdAt: attendance.createdAt,
            updatedAt: today,
            success: outTime != null ? 1 : 0,
          );
          await LocalStorage().update(cAttendance);
        } else {
          cAttendance = Attendance(
            id: await Pref().get(PrefKey.id),
            name: state.masterLatLngs[state.copyWith().indexMaster].name,
            inTime: inTime,
            outTime: outTime ?? "",
            createdAt: today,
            updatedAt: today,
            success: outTime != null ? 1 : 0,
          );
          final isInsert = await LocalStorage().insert(cAttendance);
          if (isInsert) {
            cAttendance = await LocalStorage().get(cAttendance.id);
          }
        }

        emit(
          state.copyWith(
            userLatLng: latLng,
            inTime: inTime,
            outTime: outTime,
            attendance: cAttendance,
          ),
        );
      }
    }
  }

  void _onMainToggleMap(var event, var emit) {
    final state = this.state;
    if (state is MainLoaded) {
      emit(state.copyWith(isShowMap: !state.isShowMap));
    }
  }

  void _onMainResetAttendance(var event, var emit) {
    final state = this.state;
    if (state is MainLoaded) {
      emit(MainLoaded(
        inTime: null,
        outTime: null,
        userLatLng: null,
        isShowMap: state.copyWith().isShowMap,
        masterLatLng: state.copyWith().masterLatLng,
        indexMaster: state.copyWith().indexMaster,
        mapController: state.copyWith().mapController,
        masterLatLngs: state.copyWith().masterLatLngs,
        attendance: null,
      ));
    }
  }

  void _onMainChangeMaster(OnMainChangeMaster event, var emit) {
    final state = this.state;
    if (state is MainLoaded) {
      final latLng = event.latLng;
      final mapController = state.copyWith().mapController;
      mapController.move(latLng, 18);
      emit(state.copyWith(
        masterLatLng: latLng,
        indexMaster: event.index,
      ));
    }
  }

  void _onMainOpenHistory(OnMainOpenHistory event, var emit) async {
    final state = this.state;
    if (state is MainLoaded) {
      var data = await LocalStorage().all();
      event.onCallback(data);
    }
  }
}
