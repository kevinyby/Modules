#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject


+(BOOL) isPortraitDesigned ;
+(void) setIsPortraitDesigned: (BOOL)portraitDesigned ;

+(CGSize) getPortraitCanvasSize ;
+(CGSize) getLandscapeCanvasSize ;
+(void) setPortraitCanvasSize: (CGSize)size ;
+(void) setLandscapeCanvasSize: (CGSize)size ;


+(CGRect) getFrame: (CGRect)canvasFrame ;

+(void) adjustLabelSize: (UILabel*)label canvasFrame:(CGRect)canvasFrame ;

+(CGFloat) translateFontSize: (CGFloat)fontSize ;

+(CGFloat) canvasScreenRatioX ;
+(CGFloat) canvasScreenRatioY ;
+(CGFloat) convertCanvasY: (CGFloat)y ;
+(CGFloat) convertCanvasX: (CGFloat)x ;

@end
