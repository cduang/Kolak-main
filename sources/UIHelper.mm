#import "UIHelper.h"
#import "../Core/Obfuscate.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Implementation of the custom UIView to handle touch events
@implementation _a9DkPq7LsTv0
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self._xR3mZ28JqU1o) {
        if (view && [view window]) {
            CGPoint pointInView = [self convertPoint:point toView:view];
            if ([view pointInside:pointInView withEvent:event]) {
                return NO; 
            }
        }
    }
    return [super pointInside:point withEvent:event];
}
@end

// Implementation of the UI Helpers and Connection Verification
@implementation Khanhios (UIHelpers)



#pragma mark - Security Helpers

- (NSString *)decodeBase64:(NSString *)encodedString {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encodedString options:0];
    return [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
}



- (void)forceCloseApp {
    NSLog(@"%@", @(ENCRYPT("CERRANDO APP - تم إغلاق التطبيق بالقوة.")));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@(ENCRYPT("إغلاق التطبيق"))
                                                                       message:@(ENCRYPT("تم إغلاق التطبيق بالقوة."))
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [[self topViewController] presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                exit(0);
            });
        }];
    });
}

- (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    return rootViewController;
}

@end
