// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:record_widget/src/frame.dart';

abstract class Exporter {
  Directory directory_folder_render;
  Exporter({
    required this.directory_folder_render,
  });
  void onNewFrame(Frame frame);

  Future<List<int>?> export();
}
