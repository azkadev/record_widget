// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record_widget/record_widget.dart';
import "package:path/path.dart" as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  RecordWidgetController controller = RecordWidgetController(
    pixelRatio: 1.0,
    directory_folder_render: Directory(path.join(Directory.current.path, "result")),
  );

  bool is_stop = false;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.start();
      Timer.periodic(const Duration(microseconds: 1), task);
    });
  }

  task(Timer timer) async {
    if (is_stop) {
      return;
    }
    // await Future.delayed(Duration(milliseconds: 500));
    // print("object");

    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return RecordWidget(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Center(
                child: Text(
                  '${_counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.start();
                },
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.stop();
                },
                child: const Text('Stop'),
              ),
              ElevatedButton(
                onPressed: () async {
                  controller.stop();
                  setState(() {
                    is_stop = true;
                  });

                  Future(() async {
                    bool is_saved = await controller.renderToVideoMp4(
                      outputFile: File(
                        path.join(
                          controller.directory_folder_render.path,
                          "output.mp4",
                        ),
                      ),
                    );

                    print(is_saved);

                    setState(() {
                      is_stop = false;
                    });
                  });
                },
                child: const Text('Render To Video'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
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
}
