import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:microphone_stream/microphone_stream.dart';

class Visualizer extends StatefulWidget {
  static const String tag = 'VisualizerScreen';

  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {
  Int16List _byteData;

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Visualizer'),
        ),
        body: ListView(children: [
          SizedBox(height: 15.0),
          Text('TODO'),
        ]));
  }
}
