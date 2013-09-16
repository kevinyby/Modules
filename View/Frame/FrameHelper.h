#import <Foundation/Foundation.h>

@interface FrameHelper : NSObject

+(Boolean) isNeedReserve ;
+(void) isNeedReserve: (Boolean)isNeed ;

+(void) setFrame: (CGRect)canvas view:(UIView*)view ;
+(void) translateCanvas: (CGRect)canvas view:(UIView*)view ;
+(void) translateFontLabel: (UILabel*)label ;
+(void) setFrameByOrientation: (UIInterfaceOrientation)interfaceOrientation view:(UIView*)view ;

@end
