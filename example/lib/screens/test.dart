import 'package:flutter/material.dart';
import 'package:microphone_stream/microphone_stream.dart';

class TestView extends StatefulWidget {
  @override
  State createState() => TestViewState();
}

class TestViewState extends State<TestView> {
  bool _isRecording = false;
  List<int> _samples = [];

  void _handleSamples(List<int> samples) {
    setState(() {
      _samples.addAll(samples);
      print(samples.length);
    });
  }

  void handleSpeechResponse(dynamic response) {
    print(response.runtimeType);
    print(response);
  }

  void _recordingPressed() async {
    if (_isRecording) {
      await MicrophoneStream.stopListening();
      MicrophoneStream.removeSubscriber(_handleSamples);
      _isRecording = false;
      print(_samples.length);
      _samples.clear();
    } else {
      MicrophoneStream.addSubscriber(_handleSamples);
      await MicrophoneStream.startListening();
      _isRecording = true;
    }
  }

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isRecording ? 'Recording' : 'Ready',
              style: Theme.of(context).textTheme.display1,
            ),
            if (_isRecording) Text(
                'Samples: ${_samples.length}',
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _recordingPressed,
        tooltip: 'Increment',
        child: Icon(Icons.record_voice_over),
      ),
    );
  }
}