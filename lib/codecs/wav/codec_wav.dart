import 'dart:convert';
import 'dart:io';

import 'package:microphone_stream/utility/array_converters.dart';
import 'package:microphone_stream/utility/num_converters.dart';

class WavCodec {
  static void encode(String path, List<int> sampleData, { int sampleRate = 44100, int bitsPerSample = 16, int channels = 1 }) {
    final int byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    final int blockAlign = channels * bitsPerSample ~/ 8;

    List<int> headerData = List<int>(44);

    // Header 1
    headerData.setRange(0 , 4 , ascii.encode('RIFF'));
    headerData.setRange(4 , 8 , int32ToUint8(36 + sampleData.length));
    headerData.setRange(8 , 12, ascii.encode('WAVE'));

    // Header 2
    headerData.setRange(12, 16, ascii.encode('fmt '));
    headerData.setRange(16, 20, int32ToUint8(16));
    headerData.setRange(20, 22, int16ToUint8(1));
    headerData.setRange(22, 24, int16ToUint8(channels));
    headerData.setRange(24, 28, int32ToUint8(sampleRate));
    headerData.setRange(28, 32, int32ToUint8(byteRate));
    headerData.setRange(32, 34, int16ToUint8(blockAlign));
    headerData.setRange(34, 36, int16ToUint8(bitsPerSample));

    // Data
    headerData.setRange(36, 40, ascii.encode('data'));
    headerData.setRange(40, 44, int32ToUint8(sampleData.length));

    var file = new File(path);
    file.writeAsBytesSync(headerData + sampleData);
  }

  static List<int> decode(String path) {
    var file = new File(path);
    var bytes = file.readAsBytesSync();
    
    String riff = ascii.decode(bytes.sublist(0, 4));
    String wave = ascii.decode(bytes.sublist(8, 12));
    String fmt = ascii.decode(bytes.sublist(12, 16));
    String data = ascii.decode(bytes.sublist(36, 40));

    assert(riff == 'RIFF');
    assert(wave == 'WAVE');
    assert(fmt  == 'fmt ');
    assert(data == 'data');

    return bytes.sublist(44);
  }
}
