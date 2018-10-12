//
//  MicrophoneStream.swift
//  microphone_stream
//
//  Created by Andrew Ackerman on 9/20/18.
//

import Foundation
import AVFoundation

protocol MicrophoneStreamDelegate {
    func processSampleData(_ data: Data) -> Void
}

class MicrophoneController {
    var remoteIOUnit: AudioComponentInstance?
    var delegate: MicrophoneStreamDelegate!
    var prepared = false

    static var sharedInstance = MicrophoneController()
    private init() {}

    deinit {
        AudioComponentInstanceDispose(remoteIOUnit!)
    }

    func prepare(sampleRate specifiedSampleRate: Int) -> OSStatus {
        var status = noErr

        if prepared { return status }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            try session.setPreferredInputNumberOfChannels(1)
            try session.setPreferredIOBufferDuration(0.93)
            print("Buffer duration set to \(session.preferredIOBufferDuration) seconds")
        } catch {
            return -1
        }
        
        var sampleRate = session.sampleRate
        print("Hardware sample rate = \(sampleRate), using specified rate = \(specifiedSampleRate)")
        sampleRate = Double(specifiedSampleRate)

        var audioComponentDescription = AudioComponentDescription()
        audioComponentDescription.componentType = kAudioUnitType_Output
        audioComponentDescription.componentSubType = kAudioUnitSubType_RemoteIO
        audioComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple
        audioComponentDescription.componentFlags = 0
        audioComponentDescription.componentFlagsMask = 0

        let remoteIOComponent = AudioComponentFindNext(nil, &audioComponentDescription)
        status = AudioComponentInstanceNew(remoteIOComponent!, &remoteIOUnit)
        if status != noErr {
            return status
        }

        let bus1: AudioUnitElement = 1
        var oneFlag: UInt32 = 1

        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Input,
                                      bus1,
                                      &oneFlag,
                                      UInt32(MemoryLayout<UInt32>.size))

        if status != noErr {
            return status
        }

        var asbd = AudioStreamBasicDescription()
        asbd.mSampleRate = sampleRate
        asbd.mFormatID = kAudioFormatLinearPCM
        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
        asbd.mBytesPerPacket = 2
        asbd.mFramesPerPacket = 1
        asbd.mBytesPerFrame = 2
        asbd.mChannelsPerFrame = 1
        asbd.mBitsPerChannel = 16
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioUnitProperty_StreamFormat,
                                      kAudioUnitScope_Output,bus1,
                                      &asbd,
                                      UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        
        if status != noErr {
            return status
        }

        var callbackStruct = AURenderCallbackStruct()
        callbackStruct.inputProc = microphoneControllerCallback
        callbackStruct.inputProcRefCon = nil
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioOutputUnitProperty_SetInputCallback,
                                      kAudioUnitScope_Global,
                                      bus1,
                                      &callbackStruct,
                                      UInt32(MemoryLayout<AURenderCallbackStruct>.size))

        if status != noErr {
            return status
        }

        status = AudioUnitInitialize(remoteIOUnit!)

        prepared = true
        return status
    }

    func start() -> OSStatus {
        return AudioOutputUnitStart(remoteIOUnit!)
    }

    func stop() -> OSStatus {
        return AudioOutputUnitStop(remoteIOUnit!)
    }
}

func microphoneControllerCallback(inRefCon: UnsafeMutableRawPointer,
                                  ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                                  inTimeStamp: UnsafePointer<AudioTimeStamp>,
                                  inBusNumber: UInt32,
                                  inNumberFrames: UInt32,
                                  ioData: UnsafeMutablePointer<AudioBufferList>?) -> OSStatus {

    var status = noErr

    let channelCount: UInt32 = 1

    var bufferList = AudioBufferList()
    bufferList.mNumberBuffers = channelCount
    let buffers = UnsafeMutableBufferPointer<AudioBuffer>(start: &bufferList.mBuffers,
                                                          count: Int(bufferList.mNumberBuffers))
    buffers[0].mNumberChannels = 1
    buffers[0].mDataByteSize = inNumberFrames * 2
    buffers[0].mData = nil

    status = AudioUnitRender(MicrophoneController.sharedInstance.remoteIOUnit!,
                             ioActionFlags,
                             inTimeStamp,
                             inBusNumber,
                             inNumberFrames,
                             UnsafeMutablePointer<AudioBufferList>(&bufferList))

    if status != noErr {
        return status
    }

    let data = Data(bytes: buffers[0].mData!, count: Int(buffers[0].mDataByteSize))
    DispatchQueue.main.async {
        MicrophoneController.sharedInstance.delegate.processSampleData(data)
    }

    return noErr
}

