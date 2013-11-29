#import <Foundation/Foundation.h>

@interface FrameHelper : NSObject

+(Boolean) isNeedReserve ;
+(void) isNeedReserve: (Boolean)isNeed ;

+(void) setFrame: (CGRect)canvas view:(UIView*)view ;

+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas;

// deprecated
+(void) translateCanvas: (CGRect)canvas view:(UIView*)view ;

@end
