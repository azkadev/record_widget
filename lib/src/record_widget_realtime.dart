// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:record_widget/src/record_widget_controller.dart';

// class RecordWidget extends StatelessWidget {
//   /// The child which should be recorded.
//   final Widget child;

//   /// This controller starts and stops the recording.
//   final RecordWidgetController controller;

//   const RecordWidget({
//     super.key,
//     required this.child,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       key: controller.containerKey,
//       child: child,
//     );
//   }
// }

class RecordWidgetRealtime extends StatefulWidget {
  /// The child which should be recorded.
  final Widget child;

  /// This controller starts and stops the recording.
  final RecordWidgetController controller;

  const RecordWidgetRealtime({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<RecordWidgetRealtime> createState() => _RecordWidgetRealtimeState();
}

class _RecordWidgetRealtimeState extends State<RecordWidgetRealtime> {
  bool is_dispose = false;
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Timer.periodic(const Duration(microseconds: 1), timerCallback);
    });
  }

  void timerCallback(Timer timer) {
    print(DateTime.now().difference(dateTime));

    if (is_dispose) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    is_dispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.controller.containerKey,
      child: widget.child,
    );
  }
}
