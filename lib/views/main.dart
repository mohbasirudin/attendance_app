import 'package:attendanceapp/base/apps.dart';
import 'package:attendanceapp/base/colors.dart';
import 'package:attendanceapp/base/const.dart';
import 'package:attendanceapp/helper/ext_widget.dart';
import 'package:attendanceapp/other/notif.dart';
import 'package:attendanceapp/state/main/main_bloc.dart';
import 'package:attendanceapp/views/subs/map.dart';
import 'package:attendanceapp/views/subs/top.dart';
import 'package:attendanceapp/widgets/page/error.dart';
import 'package:attendanceapp/widgets/page/loading.dart';
import 'package:attendanceapp/widgets/text/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        automaticallyImplyLeading: false,
        title: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state is MainLoaded) {
              return CTitle(state.masterLatLngs[state.indexMaster].name);
            }
            return const CTitle(Apps.name);
          },
        ),
        actions: _action(),
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

  List<Widget> _action() {
    return [
      BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoaded) {
            return PopupMenuButton(
              itemBuilder: (context) => List.generate(
                state.masterLatLngs.length,
                (i) {
                  var master = state.masterLatLngs[i];
                  return PopupMenuItem(
                    child: Text(
                      master.name,
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      var inTime = state.copyWith().inTime;
                      if (inTime != null) {
                        snackbar(
                          context,
                          isSuccess: false,
                          message:
                              "Finish your attendance first before change location",
                        );
                      } else {
                        bloc.add(OnMainChangeMaster(
                          index: i,
                          latLng: master.latLng,
                        ));
                      }
                    },
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    ];
  }

  Widget _body(MainLoaded state) {
    return Column(
      children: [
        MainTop(bloc: bloc, state: state),
        MainMap(bloc: bloc, state: state).expanded().show(
              state.copyWith().isShowMap,
            ),
      ],
    );
  }

  Widget _fab(MainLoaded state) {
    var isShowMap = state.copyWith().isShowMap;
    return ElevatedButton(
      onPressed: () {
        bloc.add(OnMainToggleMap());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isShowMap ? BaseColors.error : BaseColors.success,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Const.radius),
        ),
      ),
      child: Text(
        isShowMap ? Const.hideMap : Const.showMap,
      ),
    );
  }
}
