#import "MicrophoneStreamPlugin.h"
#import <microphone_stream/microphone_stream-Swift.h>

@implementation MicrophoneStreamPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMicrophoneStreamPlugin registerWithRegistrar:registrar];
}
@end
