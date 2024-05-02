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
// ignore_for_file: unused_field, unused_local_variable, unused_import, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:async';

// import 'dart:isolate';

import 'package:flutter/material.dart';

import 'package:image/image.dart' as image;
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/foundation.dart';
import 'package:record_widget/src/frame.dart';
import 'package:record_widget/src/image/image_exporter.dart';
import 'package:stream_channel/isolate_channel.dart';
import "package:path/path.dart" as path;
import 'package:universal_io/io.dart';

ImageExporter imageExporter({
  required Directory directory_folder_render,
}) {
  return IoImageExporter(directory_folder_render: directory_folder_render);
}

class IoImageExporter implements ImageExporter {
  @override
  Directory directory_folder_render;

  final StreamController _controller = StreamController();

  int frame_index = 0;
  IoImageExporter({
    required this.directory_folder_render,
  }) {
    _controller.stream.listen((event) async {
      if (event is Frame) {
        final i = await event.image.toByteData(format: ui.ImageByteFormat.png);
        if (i != null) {
          frame_index++;
          Future(() async {
            if (kDebugMode) {
              // print("new frame: ${frame_index}");
            }
            var res = i.buffer.asUint8List();
            final decodedImage = image.decodePng(res);
            File file = File(
              path.join(directory_folder_render.path, "${frame_index}.png"),
            );
            await file.writeAsBytes(res);
          });
          // channel!.sink.add(RawFrame(16, i));
        } else {
          if (kDebugMode) {
            print('Skipped frame while enconding');
          }
        }
      }
    });
  }
  @override
  void onNewFrame(Frame frame) {
    _controller.add(frame);
  }
}

class RawFrame {
  final int durationInMillis;
  final ByteData image;
  RawFrame(this.durationInMillis, this.image);
}
