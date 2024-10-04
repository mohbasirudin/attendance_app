import 'package:flutter/widgets.dart';

extension ExtWidget on Widget {
  Widget expanded() {
    return Expanded(child: this);
  }

  Widget show(bool value) {
    return Visibility(
      visible: value,
      child: this,
    );
  }
}
