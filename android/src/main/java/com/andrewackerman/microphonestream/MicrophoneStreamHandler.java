package com.andrewackerman.microphonestream;

public interface MicrophoneStreamHandler {
    void processSampleData(short[] data);
}
