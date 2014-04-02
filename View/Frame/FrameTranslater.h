#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject


#pragma mark -
+(CGSize) canvasSize;
+(void) setCanvasSize: (CGSize)canvas;


#pragma mark -
+(NSArray*) screenCanvasRatio ;


#pragma mark -
+(void) transformView: (UIView*)view;
+(CGFloat) convertFontSize: (CGFloat)fontSize ;


#pragma mark -
+(CGRect) convertCanvasRect: (CGRect)canvasFrame ;
+(CGPoint) convertCanvasPoint: (CGPoint)point;
+(CGSize) convertCanvasSize: (CGSize)size;

+(CGFloat) convertCanvasHeight: (CGFloat)y ;
+(CGFloat) convertCanvasWidth: (CGFloat)x ;
+(CGFloat) convertCanvasY: (CGFloat)y ;
+(CGFloat) convertCanvasX: (CGFloat)x ;

@end
