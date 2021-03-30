#import "UtilsPlugin.h"
#if __has_include(<utils/utils-Swift.h>)
#import <utils/utils-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "utils-Swift.h"
#endif

@implementation UtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (@available(iOS 9, *)) {
        [SwiftUtilsPlugin registerWithRegistrar:registrar];
    } else {
        // Fallback on earlier versions
    }
}
@end
