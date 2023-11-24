# Record Widget


flutter pub add record_widget

## Quickstart

### Install library

```bash
flutter pub add record_widget
```

### Import Library
```dart
import 'package:record_widget/record_widget.dart';
```


### Example Code

```dart
class _MyHomePageState extends State<MyHomePage> {
  /// any code
  RecordWidgetController controller = RecordWidgetController(
    pixelRatio: 1.0,
    directory_folder_render: Directory(path.join(Directory.current.path, "result")),
  );
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RecordWidget(
      controller: controller,
      child: // code any widget
    );
  }
  /// any code
}
```


Render

ffmpeg -f image2 -i %01d.png output.mp4