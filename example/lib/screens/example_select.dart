import 'package:flutter/material.dart';
import 'package:microphone_stream/microphone_stream.dart';

class ExampleSelect extends StatelessWidget {
  Widget createExampleButton({
    @required BuildContext context,
    @required String text,
    @required String route,
  }) {
    return MaterialButton(
      minWidth: 200.0,
      height: 42.0,
      color: Colors.blue,
      child: Text(text),
      onPressed: () => Navigator.of(context).pushNamed(route),
    );
  }

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Select an example'),
        ),
        body: ListView(children: [
          SizedBox(height: 15.0),
          MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            color: Colors.blue,
            child: Text('Get Permission'),
            onPressed: () async {
              bool hasPerm = await MicrophoneStream.checkPermissions();
              print("has permission: $hasPerm");

              if (!hasPerm) {
                bool gotPerm = await MicrophoneStream.requestPermissions();
                print("requested permissions successfully: $gotPerm");
              }
            },
          ),
          SizedBox(height: 15.0),
          createExampleButton(
              context: cxt, text: 'Visualizer', route: '/visualizer'),
          SizedBox(height: 15.0),
          createExampleButton(
              context: cxt, text: 'Recorder', route: '/recorder'),
        ]));
  }
}
