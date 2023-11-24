import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui show Image;

import 'package:record_widget/src/exporter.dart';
import 'package:record_widget/src/frame.dart';
import 'package:record_widget/src/gif/gif_exporter.dart';

class ScreenRecorderController {
  final Directory directory_folder_render;
  ScreenRecorderController({
    required this.directory_folder_render,
    Exporter? exporter,
    this.pixelRatio = 1.0,
    this.skipFramesBetweenCaptures = 2,
    SchedulerBinding? binding,
  })  : _containerKey = GlobalKey(),
        _binding = binding ?? SchedulerBinding.instance,
        exporter = exporter ?? GifExporter(directory_folder_render: directory_folder_render);

  final GlobalKey _containerKey;
  final SchedulerBinding _binding;
  final Exporter exporter;

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

  bool _record = false;

  void start() {
    // only start a video, if no recording is in progress
    if (_record == true) {
      return;
    }
    _record = true;
    _binding.addPostFrameCallback(postFrameCallback);
  }

  void stop() {
    _record = false;
  }

  void postFrameCallback(Duration timestamp) async {
    if (_record == false) {
      return;
    }
    if (skipped > 0) {
      // count down frames which should be skipped
      skipped = skipped - 1;

      // add a new PostFrameCallback to know about the next frame
      _binding.addPostFrameCallback(postFrameCallback);
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
        print('capture returned null');
        return;
      }
      exporter.onNewFrame(Frame(timestamp, image));
    } catch (e) {
      print(e.toString());
    }
    _binding.addPostFrameCallback(postFrameCallback);
  }

  ui.Image? capture() {
    final renderObject = _containerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    return renderObject.toImageSync(pixelRatio: pixelRatio);
  }

  Future<List<int>?> export() => exporter.export();
}

class ScreenRecorder extends StatelessWidget {
  ScreenRecorder({
    Key? key,
    required this.child,
    required this.controller,
    required this.width,
    required this.height,
    this.background = Colors.white,
  })  : assert(background.alpha == 255, 'background color is not allowed to be transparent'),
        super(key: key);

  /// The child which should be recorded.
  final Widget child;

  /// This controller starts and stops the recording.
  final ScreenRecorderController controller;

  /// Width of the recording.
  /// This should not change during recording as it could lead to
  /// undefined behavior.
  final double width;

  /// Height of the recording
  /// This should not change during recording as it could lead to
  /// undefined behavior.
  final double height;

  /// The background color of the recording.
  /// Transparency is currently not supported.
  final Color background;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller._containerKey,
      child: Container(
        width: width,
        height: height,
        color: background,
        child: child,
      ),
    );
  }
}
