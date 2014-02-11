#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject


#pragma mark -

+(BOOL) isPortraitDesigned ;
+(void) setIsPortraitDesigned: (BOOL)isPortrait ;

+(CGSize) portraitCanvasSize ;
+(CGSize) landscapeCanvasSize ;
+(void) setPortraitCanvasSize: (CGSize)size ;
+(void) setLandscapeCanvasSize: (CGSize)size ;



#pragma mark -
+(NSArray*) screenCanvasRatio ;


#pragma mark -
+(void) transformView: (UIView*)view;
+(CGFloat) convertFontSize: (CGFloat)fontSize ;


#pragma mark -

+(CGRect) convertFrame: (CGRect)canvasFrame ;
+(CGPoint) convertCanvasPoint: (CGPoint)point;
+(CGSize) convertCanvasSize: (CGSize)size;

+(CGFloat) convertCanvasHeight: (CGFloat)y ;
+(CGFloat) convertCanvasWidth: (CGFloat)x ;
+(CGFloat) convertCanvasY: (CGFloat)y ;
+(CGFloat) convertCanvasX: (CGFloat)x ;

@end
