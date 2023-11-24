// ignore_for_file: non_constant_identifier_names


import 'package:flutter/material.dart';

import 'package:record_widget/src/record_widget_controller.dart';
 
class RecordWidget extends StatelessWidget {
  /// The child which should be recorded.
  final Widget child;

  /// This controller starts and stops the recording.
  final RecordWidgetController controller;

  const RecordWidget({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.containerKey,
      child: child,
    );
  }
}
