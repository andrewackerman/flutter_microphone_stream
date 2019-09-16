import 'package:flutter/material.dart';
import 'package:microphone_stream/microphone_stream.dart';
import 'package:microphone_stream_example/screens/example_select.dart';
import 'package:microphone_stream_example/screens/recorder.dart';
import 'package:microphone_stream_example/screens/test.dart';
import 'package:microphone_stream_example/screens/visualizer.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    MicrophoneStream.requestPermissions();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Inherited',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext cxt) => TestView(),
        '/visualizer': (BuildContext cxt) => Visualizer(),
        '/recorder': (BuildContext cxt) => Recorder(),
      },
    );
  }
}
