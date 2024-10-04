part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

final class OnMainInit extends MainEvent {}

final class OnMainAddAttendanceManual extends MainEvent {
  final LatLng latLng;
  final Function(bool value, num meter) onCallback;

  const OnMainAddAttendanceManual({
    required this.latLng,
    required this.onCallback,
  });
}

final class OnMainAddAttendanceAuto extends MainEvent {
  final Function(bool value, num meter) onCallback;

  const OnMainAddAttendanceAuto({required this.onCallback});
}

final class OnMainToggleMap extends MainEvent {}

final class OnMainResetAttendance extends MainEvent {}

final class OnMainChangeMaster extends MainEvent {
  final int index;
  final LatLng latLng;

  const OnMainChangeMaster({required this.index, required this.latLng});
}

final class OnMainOpenHistory extends MainEvent {
  final Function(List<Attendance> data) onCallback;

  const OnMainOpenHistory({required this.onCallback});
}

final class OnMainToCurrentLocation extends MainEvent {}
