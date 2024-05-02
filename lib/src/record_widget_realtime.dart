/* <!-- START LICENSE -->


This Software / Program / Source Code Created By Developer From Company GLOBAL CORPORATION
Social Media:

   - Youtube: https://youtube.com/@Global_Corporation 
   - Github: https://github.com/globalcorporation
   - TELEGRAM: https://t.me/GLOBAL_CORP_ORG_BOT

All code script in here created 100% original without copy / steal from other code if we copy we add description source at from top code

If you wan't edit you must add credit me (don't change)

If this Software / Program / Source Code has you

Jika Program ini milik anda dari hasil beli jasa developer di (Global Corporation / apapun itu dari turunan itu jika ada kesalahan / bug / ingin update segera lapor ke sub)

Misal anda beli Beli source code di Slebew CORPORATION anda lapor dahulu di slebew jangan lapor di GLOBAL CORPORATION!

Jika ada kendala program ini (Pastikan sebelum deal project tidak ada negosiasi harga)
Karena jika ada negosiasi harga kemungkinan

1. Software Ada yang di kurangin
2. Informasi tidak lengkap
3. Bantuan Tidak Bisa remote / full time (Ada jeda)

Sebelum program ini sampai ke pembeli developer kami sudah melakukan testing

jadi sebelum nego kami sudah melakukan berbagai konsekuensi jika nego tidak sesuai ? 
Bukan maksud kami menipu itu karena harga yang sudah di kalkulasi + bantuan tiba tiba di potong akhirnya bantuan / software kadang tidak lengkap


<!-- END LICENSE --> */
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
