import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record_widget/record_widget.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ScreenRecorderController controller = ScreenRecorderController(pixelRatio: 1.0, directory_folder_render: Directory("/home/galaxeus/Documents/galaxeus/app/record_widget/example/test"));

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
    // await Future.delayed(Duration(milliseconds: 500));
    // print("object");

    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenRecorder(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
                  '$_counter',
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
                  var gif = await controller.export();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Image.memory(Uint8List.fromList(gif!)),
                      );
                    },
                  );
                },
                child: const Text('show recoded video'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
