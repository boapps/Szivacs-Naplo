#import "NativeHttpRequestPlugin.h"
#import <native_http_request/native_http_request-Swift.h>

@implementation NativeHttpRequestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeHttpRequestPlugin registerWithRegistrar:registrar];
}
@end
