import Flutter
import UIKit
import AVFoundation
    
public class SwiftMicrophoneStreamPlugin: NSObject, FlutterPlugin {
    
    let channel: FlutterMethodChannel
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "microphone_stream", binaryMessenger: registrar.messenger())
        let instance = SwiftMicrophoneStreamPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            
        // Utility Functions
            
        case "buildFilePath":
            result(buildFilePath(filename: call.arguments as! String))
            
        // Stream Functions
            
        case "checkPermissions":
            result(checkPermissions())
            
        case "requestPermissions":
            requestPermissions(result)
            
        case "startListening":
            startListening()
            result(true)
            
        case "stopListening":
            stopListening()
            result(true)
            
        // GVoice Functions
            
//        case "initializeGVoice":
//            let host = call.arguments[0] as! String
//            GVoiceController.sharedInstance.initialize()
//            result(true)
            
        // Default Handling
            
        default:
            result(FlutterMethodNotImplemented)
            
        }
    }

}

// MARK: Permissions

extension SwiftMicrophoneStreamPlugin {
    
    fileprivate func checkPermissions() -> Bool {
        let status = AVAudioSession.sharedInstance().recordPermission()
        switch status {
            case .undetermined:     return false
            case .denied:           return false
            case .granted:          return true
        }
    }
    
    fileprivate func requestPermissions(_ result: @escaping FlutterResult) {
        if AVAudioSession.sharedInstance().responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                result(granted ? true : false)
            })
        } else {
            result(false)
        }
    }
}

// MARK: Utilty Handlers

extension SwiftMicrophoneStreamPlugin {
    
    fileprivate func buildFilePath(filename: String) -> String {
        var components = filename.split(separator: "/")
        let file = String(components.last!)
        _ = components.popLast()
        
        var dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for comp in components {
            dir = dir.appendingPathComponent(String(comp))
        }
        
        try? FileManager.default.createDirectory(atPath: dir.path, withIntermediateDirectories: true, attributes: nil)
        
        let fullPath = dir.appendingPathComponent(file)
        return fullPath.path
    }
    
}

// MARK: Microphone Handlers

extension SwiftMicrophoneStreamPlugin : MicrophoneStreamDelegate {
    
    func startListening() {
        MicrophoneController.sharedInstance.delegate = self
        _ = MicrophoneController.sharedInstance.prepare(sampleRate: 44100)
        _ = MicrophoneController.sharedInstance.start()
    }
    
    func stopListening() {
        _ = MicrophoneController.sharedInstance.stop()
    }
    
    func processSampleData(_ data: Data) {
        self.channel.invokeMethod("handleSamples", arguments: [UInt8](data))
        
        
        
//        data.withUnsafeBytes { (pointer: UnsafePointer<Int16>) in
//            let buffer = UnsafeBufferPointer(start: pointer, count: data.count / 2)
//            let array = Array<Int16>(buffer)
//            self.channel.invokeMethod("handleSamples", arguments: array)
//        }
    }
    
}
