import 'package:attendanceapp/base/colors.dart';
import 'package:attendanceapp/base/const.dart';
import 'package:attendanceapp/other/notif.dart';
import 'package:attendanceapp/state/main/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MainMap extends StatefulWidget {
  final MainBloc bloc;
  final MainLoaded state;
  const MainMap({
    super.key,
    required this.bloc,
    required this.state,
  });

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final state = widget.state;

    return _body(bloc, state);
  }

  Widget _body(MainBloc bloc, MainLoaded state) {
    var cLocation = state.copyWith().masterLatLng ?? const LatLng(0, 0);
    final userLocation = state.copyWith().userLatLng;

    return FlutterMap(
      mapController: state.mapController,
      options: MapOptions(
        initialCenter: cLocation,
        initialZoom: 18,
        onTap: (pos, latlang) {
          bloc.add(OnMainAddAttendanceManual(
            latLng: latlang,
            onCallback: (value, meter) {
              snackbar(
                context,
                isSuccess: value,
                message: "${Const.attendance}: "
                    "${value ? Const.success : Const.messageOutOfRange}"
                    "${value ? '' : ' ($meter ${Const.meter})'}",
              );
            },
          ));
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'id.basirudin.attendanceapp',
        ),
        MarkerLayer(
          markers: [
            if (userLocation != null)
              Marker(
                point: userLocation,
                child: const Icon(
                  Icons.person_pin_circle,
                  color: Colors.red,
                  size: 24,
                ),
              ),
            Marker(
              point: cLocation,
              width: 100,
              height: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.masterLatLngs[state.copyWith().indexMaster].name),
                  const Icon(
                    Icons.place_rounded,
                    color: Colors.blue,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: cLocation,
              radius: 50,
              useRadiusInMeter: true,
              color: BaseColors.success.withOpacity(0.2),
              borderColor: BaseColors.success.withOpacity(0.7),
              borderStrokeWidth: 1,
            ),
          ],
        ),
      ],
    );
  }
}
