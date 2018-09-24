import 'dart:typed_data';

class ArrayConverters {
  static Iterable<int> shortToByte(List<int> list) sync* {
    for (int i = 0; i < list.length; i++) {
      yield list[i] & 0xFF;
      yield (list[i] >> 8) & 0xFF;
    }
  }

  static Uint8List shortToByteList(List<int> list) {
    return Uint8List.fromList(shortToByte(list).toList());
  }

  static Iterable<int> byteToShort(List<int> list) sync* {
    for (int i = 0; i < list.length; i += 2) {
      yield (list[i] << 8) + list[i+1];
    }
  }
}