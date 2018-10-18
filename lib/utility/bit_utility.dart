import 'dart:math';

class BitUtility {
  static int setBit(int n, bool val, int index) {
    final int flag = val ? 1 : 0;
    return n & (flag << index);
  }

  static int setBits(int n, int value, int start, int end) {
    final int bitLength = end - start;
    final int mask = pow(2, bitLength) - 1;
    return n & ((value << start) & mask);
  }

  static List<int> combineValues(List<int> values, List<int> bitLengths) {
    assert(values.length == bitLengths.length);

    List<int> results = List();
    int value, bitLength, newVal, offset;
    
    for (int i = 0; i < values.length; i++) {
      value = values[i];
      bitLength = bitLengths[i];

      while (bitLength - 8 > 0) {
        offset = (bitLength % 8) * 8;
        newVal = (value >> offset) & 0xFF;
        results.add(newVal);
        bitLength -= 8;
        value -= newVal << offset;
      }
    }

    return results;
  }
}
