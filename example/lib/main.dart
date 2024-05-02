/* <!-- START LICENSE -->


This Software / Program / Source Code Created By Developer From Company GLOBAL CORPORATION
Social Media:

   - Youtube: https://youtube.com/@Global_Corporation 
   - Github: https://github.com/globalcorporation
   - TELEGRAM: https://t.me/GLOBAL_CORP_ORG_BOT

All code script in here created 100% original without copy / steal from other code if we copy we add description source at from top code

If you wan't edit you must add credit me (don't change)

If this Software / Program / Source Code has you

Jika Program ini milik anda dari hasil beli jasa developer di (Global Corporation / apapun itu dari turunan itu jika ada kesalahan / bug / ingin update segera lapor ke sub)

Misal anda beli Beli source code di Slebew CORPORATION anda lapor dahulu di slebew jangan lapor di GLOBAL CORPORATION!

Jika ada kendala program ini (Pastikan sebelum deal project tidak ada negosiasi harga)
Karena jika ada negosiasi harga kemungkinan

1. Software Ada yang di kurangin
2. Informasi tidak lengkap
3. Bantuan Tidak Bisa remote / full time (Ada jeda)

Sebelum program ini sampai ke pembeli developer kami sudah melakukan testing

jadi sebelum nego kami sudah melakukan berbagai konsekuensi jika nego tidak sesuai ? 
Bukan maksud kami menipu itu karena harga yang sudah di kalkulasi + bantuan tiba tiba di potong akhirnya bantuan / software kadang tidak lengkap


<!-- END LICENSE --> */
// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record_widget/record_widget.dart';
import "package:path/path.dart" as path;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Record Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Record Widget'),
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
    directory_folder_render:
        Directory(path.join(Directory.current.path, "result")),
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
    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return RecordWidgetRealtime(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You have pushed the button this many times:',
              ),
              Center(
                child: Text(
                  '${_counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    controller.start();
                  },
                  child: const Text('Start'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    controller.stop();
                  },
                  child: const Text('Stop'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
