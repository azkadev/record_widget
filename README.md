# Record Widget

Record widget sebuah library untuk merekam widget rendering / apapun yang ada perubahan secara realtime dengan menyimpan ke gambar (png) dahulu karena jika langsung ke video saat ini belum bisa, dan untuk melakukan convert ke video kamu perlu menginstall FFMPEG untuk menconvert banyak gambar ke video

## Demo

![]()

---

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
      // auto start record on first display widget
      controller.start();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return RecordWidget(
      controller: controller,
      child: Scaffold( 
        body: // code any widget,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // stop and render to file ./output.mp4
            controller.stop();
            Future(() async {
              bool is_save = await controller.renderToVideoMp4(outputFile: File("./output.mp4"));
              print(is_save ? "Succes" : "Gagal");
            });
          },
          tooltip: 'Stop',
          child: const Icon(Icons.stop),
        ),
      ),
    );
  }
  /// any code
}
```

## Render
```bash
ffmpeg -f image2 -i %01d.png output.mp4
```