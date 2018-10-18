import 'package:flutter/material.dart';
import 'package:microphone_stream/microphone_stream.dart';

class Recorder extends StatefulWidget {
  static const String tag = 'RecorderScreen';

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  List<int> sampleData = List();

  void sampleSubscriber(List<int> samples) {
    sampleData.addAll(samples);
    print(sampleData.length);
  }

  void startListening() {
    print('Starting to listen...');
    MicrophoneStream.addSubscriber(sampleSubscriber);
    MicrophoneStream.startListening();
  }

  void stopListening() {
    print('Not listening anymore');
    MicrophoneStream.removeSubscriber(sampleSubscriber);
    MicrophoneStream.stopListening();
  }

  void saveRecording() async {
    final String path =
        await MicrophoneUtility.buildFilePath('recordings/sample.wav');
    WavCodec.encode(path, sampleData);
    print('Recording saved to $path');
  }

  // @override
  // void initState() {
  //   MicrophoneUtility.buildFilePath('dir1/dir2/dir3/test.txt').then((value) => print(value));
  //   super.initState();
  // }

  Widget buildButton({String text, Function callback}) {
    return MaterialButton(
      minWidth: 200.0,
      height: 42.0,
      color: Colors.blue,
      child: Text(text),
      onPressed: callback,
    );
  }

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Recorder'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 15.0),
          buildButton(text: 'Start', callback: startListening),
          SizedBox(height: 15.0),
          buildButton(text: 'Stop', callback: stopListening),
          SizedBox(height: 15.0),
          buildButton(text: 'Save', callback: saveRecording),
        ],
      ),
    );
  }
}
