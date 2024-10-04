part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

final class OnMainInit extends MainEvent {}

final class OnMainAddAttendanceManual extends MainEvent {
  final LatLng latLng;
  final Function(bool value) onCallback;

  const OnMainAddAttendanceManual({
    required this.latLng,
    required this.onCallback,
  });
}

final class OnMainAddAttendanceAuto extends MainEvent {
  final Function(bool value) onCallback;

  const OnMainAddAttendanceAuto({required this.onCallback});
}
