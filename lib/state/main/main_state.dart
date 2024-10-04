part of 'main_bloc.dart';

sealed class MainState extends Equatable {
  const MainState();

  @override
  List<dynamic> get props => [];
}

final class MainInitial extends MainState {}

final class MainLoading extends MainState {}

final class MainLoaded extends MainState {
  final LatLng? masterLatLng;
  final LatLng? userLatLng;
  final bool isShowMap;
  final String? inTime;
  final String? outTime;
  final List<Master> masterLatLngs;
  final int indexMaster;
  final MapController mapController;
  final Attendance? attendance;

  const MainLoaded({
    this.masterLatLng,
    this.userLatLng,
    this.isShowMap = true,
    this.inTime,
    this.outTime,
    this.masterLatLngs = const [],
    this.indexMaster = 0,
    required this.mapController,
    this.attendance,
  });

  MainLoaded copyWith({
    LatLng? masterLatLng,
    LatLng? userLatLng,
    bool? isShowMap,
    String? inTime,
    String? outTime,
    List<Master>? masterLatLngs,
    int? indexMaster,
    MapController? mapController,
    Attendance? attendance,
  }) {
    return MainLoaded(
      masterLatLng: masterLatLng ?? this.masterLatLng,
      userLatLng: userLatLng ?? this.userLatLng,
      isShowMap: isShowMap ?? this.isShowMap,
      inTime: inTime ?? this.inTime,
      outTime: outTime ?? this.outTime,
      masterLatLngs: masterLatLngs ?? this.masterLatLngs,
      indexMaster: indexMaster ?? this.indexMaster,
      mapController: mapController ?? this.mapController,
      attendance: attendance ?? this.attendance,
    );
  }

  @override
  List<dynamic> get props => [
        masterLatLng,
        userLatLng,
        isShowMap,
        inTime,
        outTime,
        masterLatLngs,
        indexMaster,
        mapController,
        attendance,
      ];
}

final class MainError extends MainState {
  final String? message;

  const MainError({this.message});
}
