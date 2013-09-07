#import <Foundation/Foundation.h>

@interface FrameHelper : NSObject

+(void) translateCanvas: (CGRect)canvas view:(UIView*)view ;
+(void) setFrameByOrientation: (UIInterfaceOrientation)interfaceOrientation view:(UIView*)view ;

@end
