// ignore_for_file: unused_field, unused_local_variable, unused_import, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

import 'package:image/image.dart' as image;
import 'dart:ui' as ui show ImageByteFormat;
import 'package:flutter/foundation.dart';
import 'package:record_widget/src/frame.dart';
import 'package:record_widget/src/image/image_exporter.dart';
import 'package:stream_channel/isolate_channel.dart';
import "package:path/path.dart" as path;

ImageExporter gifExporter({
  required Directory directory_folder_render,
}) {
  return IoImageExporter(directory_folder_render: directory_folder_render);
}

class IoImageExporter implements ImageExporter {
  @override
  Directory directory_folder_render;

  final StreamController _controller = StreamController();

  ReceivePort receivePort = ReceivePort();

  IsolateChannel? channel;

  Isolate? _isolate;

  int frame_index = 0;
  IoImageExporter({required this.directory_folder_render}) {
    _controller.stream.listen((event) async {
      if (event is _InitIsolateMessage) {
        await _initIsolate();
      }
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
          channel!.sink.add(RawFrame(16, i));
        } else {
          if (kDebugMode) {
            print('Skipped frame while enconding');
          }
        }
      }
    });

    _controller.add(_InitIsolateMessage());
  }

  Future<void> _initIsolate() async {
    if (kDebugMode) {
      print("init isolate");
    }
    channel = IsolateChannel.connectReceive(receivePort);

    _isolate = await Isolate.spawn<SendPort>(
      _isolateEntryPoint,
      receivePort.sendPort,
      debugName: 'ImageExporterIsolate',
    );
  }

  @override
  Future<List<int>?> export() async {
    channel!.sink.add(_ExportMessage());
    return await channel!.stream.first;
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

void _isolateEntryPoint(SendPort sendPort) {
  final exporter = _InternalExporter();
  IsolateChannel channel = IsolateChannel.connectSend(sendPort);
  channel.stream.listen((message) {
    if (message is RawFrame) {
      exporter.add(message);
    }
    if (message is _ExportMessage) {
      final gif = exporter.export();
      channel.sink.add(gif);
    }
  });
}

class _InternalExporter {
  // late image.Animation animation;

  _InternalExporter() {
    // animation = image.Animation();
    // animation.backgroundColor = Colors.transparent.value;
  }

  void add(RawFrame rawFrame) {
    final iAsBytes = rawFrame.image.buffer.asUint8List();
    // final decodedImage = image.decodePng(iAsBytes);

    // if (decodedImage == null) {
    //   print('Skipped frame while enconding');
    //   return;
    // }
    // // decodedImage.duration = rawFrame.durationInMillis;
    // animation.addFrame(decodedImage);
  }

  List<int>? export() {
    // image.encodeImageAnimation(animation);
    return null;
  }
}

class _ExportMessage {}

class _InitIsolateMessage {}
