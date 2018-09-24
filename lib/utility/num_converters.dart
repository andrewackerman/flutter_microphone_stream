

List<int> numberToBytes(int val, int byteCount, {int offset = 0, bool littleEndian = true}) {
  List<int> result = List(byteCount);

  for (int i = 0; i < byteCount; i++) {
    int idx = littleEndian ? byteCount - i - 1 : i;
    result[idx] = (val >> (8 * i) + offset) & 0xFF;
  }

  return result;
}

// Int16
List<int> int16ToUint8(int val, {bool littleEndian = true}) {
  List<int> result = List(4);

  if (littleEndian) {
    result[1] = (val >> 8) & 0xFF;
    result[0] = val & 0xFF;
  } else {
    result[0] = (val >> 8) & 0xFF;
    result[1] = val & 0xFF;
  }

  return result;
}

int uint8ToInt16(List<int> val, {bool littleEndian = true}) {
  assert(val.length == 2);

  if (littleEndian) {
    return (val[1] << 8) + val[0];
  } else {
    return (val[0] << 8) + val[1];
  }
}

// Int32
List<int> int32ToUint8(int val, {bool littleEndian = true}) {
  List<int> result = List(4);

  if (littleEndian) {
    result[3] = (val >> 24) & 0xFF;
    result[2] = (val >> 16) & 0xFF;
    result[1] = (val >> 8) & 0xFF;
    result[0] = val & 0xFF;
  } else {
    result[0] = (val >> 24) & 0xFF;
    result[1] = (val >> 16) & 0xFF;
    result[2] = (val >> 8) & 0xFF;
    result[3] = val & 0xFF;
  }

  return result;
}

int uint8ToInt32(List<int> val, {bool littleEndian = true}) {
  assert(val.length == 4);

  if (littleEndian) {
    return (val[3] << 24) + (val[2] << 16) + (val[1] << 8) + val[0];
  } else {
    return (val[0] << 24) + (val[1] << 16) + (val[2] << 8) + val[3];
  }
}