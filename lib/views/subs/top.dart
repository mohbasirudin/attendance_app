import 'package:attendanceapp/base/colors.dart';
import 'package:attendanceapp/base/const.dart';
import 'package:attendanceapp/helper/ext_widget.dart';
import 'package:attendanceapp/other/notif.dart';
import 'package:attendanceapp/state/main/main_bloc.dart';
import 'package:attendanceapp/storage/init.dart';
import 'package:attendanceapp/storage/models/attendance.dart';
import 'package:flutter/material.dart';

class MainTop extends StatefulWidget {
  final MainBloc bloc;
  final MainLoaded state;
  const MainTop({
    super.key,
    required this.bloc,
    required this.state,
  });

  @override
  State<MainTop> createState() => _MainTopState();
}

class _MainTopState extends State<MainTop> {
  @override
  Widget build(BuildContext context) {
    var bloc = widget.bloc;
    var state = widget.state;
    var inTime = state.copyWith().inTime;
    var outTime = state.copyWith().outTime;
    var isIn = inTime == null;
    var isCanReset = inTime != null && outTime != null;
    return Padding(
      padding: const EdgeInsets.all(Const.padding),
      child: Column(
        children: [
          Row(
            children: [
              _child(Const.inTime,
                  value: inTime ?? "--:--", color: BaseColors.success),
              const SizedBox(width: Const.padding),
              _child(Const.outTime,
                  value: outTime ?? "--:--", color: BaseColors.error),
            ],
          ),
          const SizedBox(height: Const.padding),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  height: Const.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isCanReset) {
                        bloc.add(OnMainResetAttendance());
                      } else {
                        bloc.add(
                          OnMainAddAttendanceAuto(
                            onCallback: (value, meter) {
                              snackbar(
                                context,
                                message: "${Const.attendance}: "
                                    "${value ? Const.success : Const.messageOutOfRange} "
                                    "${value ? '' : ' ($meter ${Const.meter})'}",
                                isSuccess: value,
                              );
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCanReset
                          ? BaseColors.reset
                          : (isIn ? BaseColors.success : BaseColors.error),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Const.radius),
                      ),
                    ),
                    child: Text(isCanReset
                        ? Const.newAttendance
                        : (isIn ? Const.checkIn : Const.checkOut)),
                  ),
                ).expanded(),
                GestureDetector(
                  onTap: () {
                    bloc.add(
                      OnMainOpenHistory(
                        onCallback: (data) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _History(data: data),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Const.radius),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: Const.buttonHeight,
                    height: Const.buttonHeight,
                    margin: const EdgeInsets.only(left: Const.padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Const.radius),
                      color: BaseColors.reset,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.history_sharp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _child(
    String name, {
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(Const.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Const.radius),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(name),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).expanded();
  }
}

class _History extends StatelessWidget {
  final List<Attendance> data;
  const _History({required this.data});

  @override
  Widget build(BuildContext context) {
    print("data: ${data.length}");
    if (data.isEmpty) {
      return const Center(
        child: Text(Const.empty),
      );
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var item = data[index];
        return Column(
          children: [
            Text(item.name),
            Text(item.inTime),
            Text(item.outTime),
          ],
        );
      },
    );
  }
}
