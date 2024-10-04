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

  const MainLoaded({
    this.masterLatLng,
    this.userLatLng,
    this.isShowMap = true,
  });

  MainLoaded copyWith({
    LatLng? masterLatLng,
    LatLng? userLatLng,
    bool? isShowMap,
  }) {
    return MainLoaded(
      masterLatLng: masterLatLng ?? this.masterLatLng,
      userLatLng: userLatLng ?? this.userLatLng,
      isShowMap: isShowMap ?? this.isShowMap,
    );
  }

  @override
  List<dynamic> get props => [
        masterLatLng,
        userLatLng,
        isShowMap,
      ];
}

final class MainError extends MainState {
  final String? message;

  const MainError({this.message});
}
