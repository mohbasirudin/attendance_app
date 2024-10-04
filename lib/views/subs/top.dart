import 'package:attendanceapp/base/colors.dart';
import 'package:attendanceapp/base/const.dart';
import 'package:attendanceapp/helper/ext_widget.dart';
import 'package:attendanceapp/state/main/main_bloc.dart';
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
    return Padding(
      padding: const EdgeInsets.all(Const.padding),
      child: Column(
        children: [
          Row(
            children: [
              _child("In", value: "09:00", color: BaseColors.success),
              const SizedBox(width: Const.padding),
              _child("Out", value: "10:00", color: BaseColors.error),
            ],
          ),
          const SizedBox(height: Const.padding),
          SizedBox(
            width: double.infinity,
            height: Const.buttonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: BaseColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Const.radius),
                ),
              ),
              child: const Text("In"),
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
