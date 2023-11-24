import 'package:record_widget/src/frame.dart';

abstract class Exporter {
  void onNewFrame(Frame frame);

  Future<List<int>?> export();
}
