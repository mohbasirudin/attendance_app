import 'package:attendanceapp/base/apps.dart';
import 'package:attendanceapp/base/const.dart';
import 'package:attendanceapp/other/notif.dart';
import 'package:attendanceapp/state/main/main_bloc.dart';
import 'package:attendanceapp/views/subs/map.dart';
import 'package:attendanceapp/views/subs/top.dart';
import 'package:attendanceapp/widgets/page/error.dart';
import 'package:attendanceapp/widgets/page/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _onInit();
  }

  void _onInit() {
    bloc = context.read<MainBloc>();

    bloc.add(OnMainInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Apps.name),
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoading) {
            return const CLoading();
          }
          if (state is MainError) {
            return CError(
              message: state.message,
              onReload: _onInit,
            );
          }
          if (state is MainLoaded) {
            return _body(state);
          }

          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoaded) {
            return _fab(state);
          }

          return Container();
        },
      ),
    );
  }

  Widget _body(MainLoaded state) {
    return Column(
      children: [
        MainTop(bloc: bloc, state: state),
        Expanded(
          child: MainMap(bloc: bloc, state: state),
        ),
      ],
    );
  }

  Widget _fab(MainLoaded state) {
    return FloatingActionButton(
      onPressed: () {
        bloc.add(OnMainAddAttendanceAuto(
          onCallback: (value) {
            snackbar(
              context,
              isSuccess: value,
              message:
                  "${Const.attendance}: ${value ? Const.success : Const.failed}",
            );
          },
        ));
      },
      child: const Icon(Icons.check),
    );
  }
}
