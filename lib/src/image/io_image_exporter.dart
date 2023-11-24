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

ImageExporter gifExporter({
  required Directory directory_folder_render,
}) {
  return IoImageExporter(directory_folder_render: directory_folder_render);
}

class IoImageExporter implements ImageExporter {
  @override
  Directory directory_folder_render;

  final StreamController _controller = StreamController();

  int frame_index = 0;
  IoImageExporter({required this.directory_folder_render}) {
    _controller.stream.listen((event) async {
      if (event is Frame) {
        final i = await event.image.toByteData(format: ui.ImageByteFormat.png);
        if (i != null) {
          frame_index++;
          Future(() async {
            if (kDebugMode) {
              print("new frame: ${frame_index}");
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
