// import 'dart:convert';

// import 'package:microphone_stream/utility/num_converters.dart';

// class FlacStream {
//   List<int> toBytes() {
//     List<int> bytes = List();
//     bytes.addAll(ascii.encode('fLaC'));

//     // TODO...

//     return bytes;
//   }
// }

// class FlacMetadataBlock {
//   FlacMetadataBlockHeader header;
//   FlacMetadataBlockData data;
// }

// class FlacMetadataBlockHeader {
//   bool isLastMetadataBlock;
//   int blockType;
//   int length;
// }

// abstract class FlacMetadataBlockData {
//   List<int> getData();
// }

// class FlacMetadataBlockStreamInfo extends FlacMetadataBlockData {
//   int minBlockSize;
//   int maxBlockSize;
//   int minFrameSize;
//   int maxFrameSize;
//   int sampleRate;
//   int channels;
//   int bitsPerSample;
//   int sampleCount;
//   List<int> md5Signature;

//   @override
//   List<int> getData() {
//     List<int> data = List(34);

//     data.setRange(0 , 2 , numberToBytes(minBlockSize, 2));
//     data.setRange(2 , 4 , numberToBytes(maxBlockSize, 2));
//     data.setRange(4 , 7 , numberToBytes(minFrameSize, 3));
//     data.setRange(7 , 10, numberToBytes(maxFrameSize, 3));

//     List<int> sampleRateBytes = numberToBytes(sampleRate, 2, offset: 4);
//     int sampleRateRemainder = sampleRate & 0xF;

//     int channelAndBitsPerSample = ((channels & 0x8) << 5) + (bitsPerSample & 0x1F);

//     List<int> sampleCountBytes = numberToBytes(sampleCount, 4, offset: 4);
//     int sampleCountRemainder = sampleCount & 0xF;

//     int bit1 =
//   }
// }

// class FlacFrame {

// }

// const int kFlacMetadataBlockType_StreamInfo = 0;
// const int kFlacMetadataBlockType_Padding = 1;
// const int kFlacMetadataBlockType_Application = 2;
// const int kFlacMetadataBlockType_SeekTable = 3;
// const int kFlacMetadataBlockType_VorbisComment = 4;
// const int kFlacMetadataBlockType_CueSheet = 5;
// const int kFlacMetadataBlockType_Picture = 6;
