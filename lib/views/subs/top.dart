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
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text("In"),
                Text("09:00"),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text("In"),
                Text("09:00"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
