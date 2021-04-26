#import "FlutterZoomSdkPlugin.h"
#if __has_include(<flutter_zoom_sdk/flutter_zoom_sdk-Swift.h>)
#import <flutter_zoom_sdk/flutter_zoom_sdk-Swift.h>
#else
#import "flutter_zoom_sdk-Swift.h"
#endif

@implementation FlutterZoomSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterZoomSdkPlugin registerWithRegistrar:registrar];
}
@end
