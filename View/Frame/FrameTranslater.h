#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject


+(BOOL) isPortraitDesigned ;
+(void) setIsPortraitDesigned: (BOOL)portraitDesigned ;

+(CGSize) getPortraitCanvasSize ;
+(CGSize) setLandscapeCanvasSize ;
+(void) setPortraitCanvasSize: (CGSize)size ;
+(void) setLandscapeCanvasSize: (CGSize)size ;


+(CGRect) getFrame: (CGRect)canvasFrame ;

+(CGRect)getRotateCanvasFrame: (CGRect)canvasFrame ;

+(void) adjustLabelSize: (UILabel*)label canvasFrame:(CGRect)canvasFrame text:(NSString*)text ;

+(CGFloat) adjustFontSize: (CGFloat)fontSize ;

+(CGFloat) canvasScreenRatioX ;
+(CGFloat) canvasScreenRatioY ;
+(CGFloat) convertCanvasY: (CGFloat)y ;
+(CGFloat) convertCanvasX: (CGFloat)x ;

@end
