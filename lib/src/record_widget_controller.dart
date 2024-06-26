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
