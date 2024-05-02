// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui show Image;

import 'package:record_widget/src/exporter.dart';
import 'package:record_widget/src/frame.dart';
import 'package:record_widget/src/image/image_exporter.dart';
import "package:path/path.dart" as path;
import 'package:universal_io/io.dart';

class RecordWidgetController {
  final Directory directory_folder_render;

  final GlobalKey containerKey = GlobalKey();
  final SchedulerBinding binding = SchedulerBinding.instance;
  late final Exporter exporter;

  /// The pixelRatio describes the scale between the logical pixels and the size
  /// of the output image. Specifying 1.0 will give you a 1:1 mapping between
  /// logical pixels and the output pixels in the image. The default is a pixel
  /// ration of 3 and a value below 1 is not recommended.
  ///
  /// See [RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)
  /// for the underlying implementation.
  final double pixelRatio;

  /// Describes how many frames are skipped between caputerd frames.
  /// For example if it's `skipFramesBetweenCaptures = 2` record_widget
  /// captures a frame, skips the next two frames and then captures the next
  /// frame again.
  final int skipFramesBetweenCaptures;

  int skipped = 0;

  bool is_record = false;

  RecordWidgetController({
    required this.directory_folder_render,
    ImageExporter? imageExporter,
    this.pixelRatio = 1.0,
    this.skipFramesBetweenCaptures = 2,
    SchedulerBinding? binding,
  }) {
    if (imageExporter != null) {
      exporter = imageExporter;
    } else {
      exporter = ImageExporter(directory_folder_render: directory_folder_render);
    }
  }
  void start() {
    // only start a video, if no recording is in progress
    if (is_record == true) {
      return;
    }
    is_record = true;
    binding.addPostFrameCallback(postFrameCallback);
  }

  void stop() {
    is_record = false;
  }

  void postFrameCallback(Duration timestamp) async {
    if (is_record == false) {
      return;
    }
    if (skipped > 0) {
      // count down frames which should be skipped
      skipped = skipped - 1;

      // add a new PostFrameCallback to know about the next frame
      binding.addPostFrameCallback(postFrameCallback);
      // but we do nothing, because we skip this frame
      return;
    }
    if (skipped == 0) {
      // reset skipped frame counter
      skipped = skipped + skipFramesBetweenCaptures;
    }
    try {
      final image = capture();
      if (image == null) {
        if (kDebugMode) {
          print('capture returned null');
        }
        return;
      }
      exporter.onNewFrame(Frame(timestamp, image));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    binding.addPostFrameCallback(postFrameCallback);
  }

  ui.Image? capture() {
    final renderObject = containerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    return renderObject.toImageSync(pixelRatio: pixelRatio);
  }

  Future<bool> stopAndRenderToVideoMp4({
    required File outputFile,
  }) async {
    stop();
    return await renderToVideoMp4(outputFile: outputFile);
  }

  Future<bool> renderToVideoMp4({
    required File outputFile,
  }) async {
    var shell = await Process.start(
      "ffmpeg",
      [
        "-y",
        "-f",
        "image2",
        "-i",
        Directory(path.join(directory_folder_render.path, "%01d.png")).path,
        outputFile.path,
      ],
    );
    shell.stderr.listen(stderr.add);
    shell.stdout.listen(stdout.add);
    int exitCode = await shell.exitCode;
    return (exitCode == 0);
  }
}
