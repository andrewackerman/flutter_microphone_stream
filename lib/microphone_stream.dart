import 'dart:async';

import 'package:flutter/services.dart';

export 'codecs/wav/codec_wav.dart';
export 'codecs/flac/codec_flac.dart';
export 'channels/microphone_channel.dart';

class MicrophoneUtility {
  static const MethodChannel _channel =
    const MethodChannel('microphone_stream');

  static Future<String> buildFilePath(String filename) async {
    final String path = await _channel.invokeMethod('buildFilePath', filename);
    return path;
  }
}