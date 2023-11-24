import 'package:record_widget/record_widget.dart';

import 'io_gif_exporter.dart';

abstract class GifExporter implements Exporter {
  factory GifExporter() => gifExporter();
}
