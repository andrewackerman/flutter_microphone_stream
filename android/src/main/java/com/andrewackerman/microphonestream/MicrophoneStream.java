package com.andrewackerman.microphonestream;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.util.Log;

public class MicrophoneStream {
    private static final String TAG = "MicrophoneStream";
    private static final int SAMPLE_RATE = 44100;
    private static final int CHANNELS = 1;
    private static final int BITS_PER_SAMPLE = 2;

    private AudioRecord recorder = null;
    private int bufferSize = 1024;
    private boolean isRecording = false;
    private Thread recordingThread = null;

    private MicrophoneStreamHandler handler;

    public static final MicrophoneStream instance = new MicrophoneStream();
    private MicrophoneStream() {}

    public void prepare() {
        reset();

        int audioFormat = AudioFormat.ENCODING_PCM_16BIT;
        int channelConfig = AudioFormat.CHANNEL_IN_MONO;

        //bufferSize = AudioRecord.getMinBufferSize(SAMPLE_RATE, channelConfig, audioFormat);
        recorder = new AudioRecord(
                MediaRecorder.AudioSource.MIC,
                SAMPLE_RATE,
                channelConfig,
                audioFormat,
                bufferSize);
    }

    public void setHandler(MicrophoneStreamHandler handler) {
        this.handler = handler;
    }

    public void reset() {
        if (recorder != null) {
            recorder.release();
            recorder = null;
        }

        recordingThread = null;
    }

    public void start() {
        recordingThread = new Thread(new Runnable() {
            @Override
            public void run() {
                processAudioData();
            }
        }, "MicrophoneStream Thread");

        recorder.startRecording();
        isRecording = true;
        recordingThread.start();
    }

    public void stop() {
        isRecording = false;
    }

    private void processAudioData() {
        short[] data = new short[bufferSize / 2];

        Log.i(TAG, "Starting recording thread");

        int read = 0;
        while (isRecording) {
            read = recorder.read(data, 0, bufferSize / 2);

            if (read != AudioRecord.ERROR_INVALID_OPERATION) {
                handler.processSampleData(data);
            }
        }

        recorder.stop();
        reset();

        Log.i(TAG, "Stopping recording thread. Last read value: " + read);
    }
}
