#import <Foundation/Foundation.h>

@interface FrameHelper : NSObject

+(Boolean) isNeedReserve ;
+(void) isNeedReserve: (Boolean)isNeed ;

+(void) setFrame: (CGRect)canvas view:(UIView*)view ;


+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas;


/**
 *  Description Deprecated
 *
 *  @param canvas canvas description
 *  @param view   view description
 */
+(void) translateCanvas: (CGRect)canvas view:(UIView*)view NS_DEPRECATED_IOS(3_0,7_0);


#pragma mark -
+(CGRect) getScreenRectByOrientation;

+(void) setComponentFrame: (NSArray*)frame component:(UIView*)view;
+(void) setComponentCenter: (NSArray*)values component:(UIView*)view;

+(UIEdgeInsets) convertCanvasEdgeInsets: (UIEdgeInsets)insets;

+(void) setSubViewsFrames: (UIView*)view config:(NSDictionary*)config;

@end
