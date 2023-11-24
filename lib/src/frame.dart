import 'dart:ui' as ui show Image;

class Frame {
  Frame(this.timeStamp, this.image);

  final Duration timeStamp;
  final ui.Image image;
}
