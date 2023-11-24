// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:record_widget/record_widget.dart';

import 'io_image_exporter.dart';

abstract class ImageExporter implements Exporter {
  factory ImageExporter({
    required Directory directory_folder_render,
  }) {
    if (directory_folder_render.existsSync()) {
      directory_folder_render.deleteSync(
        recursive: true,
      );
      directory_folder_render.createSync(recursive: true);
    } else {
      directory_folder_render.createSync(recursive: true);
    }

    return gifExporter(
      directory_folder_render: directory_folder_render,
    );
  }
}
