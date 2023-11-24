// ignore_for_file: non_constant_identifier_names

import 'package:record_widget/src/frame.dart';
import 'package:universal_io/io.dart';

abstract class Exporter {
  Directory directory_folder_render;
  Exporter({
    required this.directory_folder_render,
  });
  void onNewFrame(Frame frame);
 
}
