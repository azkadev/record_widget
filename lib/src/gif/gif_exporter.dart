import 'dart:io';

import 'package:record_widget/record_widget.dart';

import 'io_gif_exporter.dart';

abstract class GifExporter implements Exporter {
  factory GifExporter({
    required Directory directory_folder_render,
  }) {

  // Directory directory = Directory("/home/galaxeus/Documents/galaxeus/app/record_widget/example/test");
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
