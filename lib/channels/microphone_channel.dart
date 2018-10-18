import 'dart:async';

import 'package:flutter/services.dart';

typedef void SampleSubscriber(List<int> byteData);

class MicrophoneStream {
  static Set<SampleSubscriber> subscribers = Set();

  static void broadcastSamples(List<int> samples) {
    subscribers.forEach((sub) => sub(samples));
  }

  static Future<dynamic> methodCallHandler(MethodCall call) async {
    final args = call.arguments;

    if (args is List<dynamic>) {
      final samples = args.cast<int>();
      broadcastSamples(samples);
    }
  }

  static const MethodChannel _channel =
      const MethodChannel('microphone_stream');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void addSubscriber(SampleSubscriber subscriber) {
    subscribers.add(subscriber);
  }

  static void removeSubscriber(SampleSubscriber subscriber) {
    subscribers.remove(subscriber);
  }

  static Future<bool> checkPermissions() async {
    final bool result = await _channel.invokeMethod('checkPermissions');
    return result;
  }

  static Future<bool> requestPermissions() async {
    final bool result = await _channel.invokeMethod('requestPermissions');
    return result;
  }

  static Future<void> startListening() async {
    _channel.setMethodCallHandler(methodCallHandler);
    await _channel.invokeMethod('startListening');
  }

  static Future<void> stopListening() async {
    await _channel.invokeMethod('stopListening');
  }
}
