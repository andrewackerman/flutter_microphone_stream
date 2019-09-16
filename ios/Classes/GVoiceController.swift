////
////  GVoiceController.swift
////  microphone_stream
////
////  Created by Andrew Ackerman on 1/28/19.
////
//
//import Foundation
//import googleapis
//
//let API_KEY = "AIzaSyD3z5dOAKUoxk3HF4EKtuH1y56nsxRBKTQ"
//let HOST    = "speech.googelapis.com"
//
//enum GVoiceStatus {
//    case invalid
//    case idle
//    case processing
//    case unavailable
//}
//
//enum GVoiceCheckResult {
//    case invalid
//    case cancel
//    case disabled
//    case enabled
//}
//
//class GVoiceController {
//    
//    static let SAMPLE_RATE = 16000
//    static let TIMER_LENGTH = 10.0
//    
//    fileprivate var streaming = false
//    fileprivate var closing = false
//    
//    private var client : Speech!
//    private var writer : GRXBufferedPipe!
//    private var call   : GRPCProtoCall!
//    
//    static let sharedInstance = GoogleSpeachService()
//    private init() {}
//    
//    func initialize(contextStrings: [String]? = nil) {
//        if streaming || closing {
//            return
//        }
//        
//        client = Speech(host: HOST)
//        writer = GRXBufferedPipe()
//        
//        call = client.rpcToStreamingRecognize(withRequestsWriter: writer, eventHandler: handleResponse)
//        call.requestHeaders.setObject(NSString(string: API_KEY), forKey: NSString(string: "X-Goog-Api-Key"))
//        call.requestHeaders.setObject(NSString(string: Bundle.main.bundleIdentifier!), forKey: NSString(string: "X-Ios-Bundle-Identifier"))
//        call.start()
//        
//        streaming = true
//        closing = false
//        
//        let recognitionConfig = RecognitionConfig()
//        recognitionConfig.encoding = .linear16
//        recognitionConfig.sampleRateHertz = Int32(sampleRate)
//        recognitionConfig.languageCode = "en-US"
//        recognitionConfig.maxAlternatives = 30
//        if let contextStrings = contextStrings {
//            let context = SpeechContext()
//            context.phrasesArray = NSMutableArray(array: contextStrings)
//            recognitionConfig.speechContextsArray = NSMutableArray(array: [context])
//        }
//        
//        let streamingRecognitionConfig = StreamingRecognitionConfig()
//        streamingRecognitionConfig.config = recognitionConfig
//        streamingRecognitionConfig.singleUtterance = false
//        streamingRecognitionConfig.interimResults = true
//        
//        let streamingRecognizeRequest = StreamingRecognizeRequest()
//        streamingRecognizeRequest.streamingConfig = streamingRecognitionConfig
//        
//        writer.writeValue(streamingRecognizeRequest)
//    }
//    
//    func consumeAudioData(_ audioData: NSData) {
//        if !streaming {
//            return
//        }
//        
//        let streamingRecognizeRequest = StreamingRecognizeRequest()
//        streamingRecognizeRequest.audioContent = audioData as Data
//        writer.writeValue(streamingRecognizeRequest)
//    }
//    
//    func stop() {
//        if !streaming {
//            return
//        }
//        
//        closing = true
//        writer.finishWithError(nil)
//    }
//    
//    func finalize() {
//        if !streaming {
//            return
//        }
//        
//        streaming = false
//        closing = false
//    }
//    
//    func isStreaming() -> Bool { return streaming }
//    
//}
//
//// MARK: Response Handler
//
//extension GVoiceController {
//    
//    func handleResponse(done: Bool, response: StreamingRecognizeResponse?, error: NSError) {
//        print("Got response:")
//        print("    done: \(done)")
//        print("    response: \(response)")
//        print("    error: \(error)")
//    }
//    
//}
