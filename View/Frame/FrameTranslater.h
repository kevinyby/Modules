#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject


+(BOOL) isPortraitDesigned ;
+(void) setIsPortraitDesigned: (BOOL)isPortrait ;

+(CGSize) portraitCanvasSize ;
+(CGSize) landscapeCanvasSize ;
+(void) setPortraitCanvasSize: (CGSize)size ;
+(void) setLandscapeCanvasSize: (CGSize)size ;


+(CGRect) getFrame: (CGRect)canvasFrame ;


+(void) transformLabel: (UILabel*)label canvas:(CGRect)canvas ;


+(NSArray*) screenCanvasRatio ;


+(CGFloat) convertFontSize: (CGFloat)fontSize ;

+(CGSize) convertCanvasSize: (CGSize)size;
+(CGPoint) convertCanvasPoint: (CGPoint)point;

+(CGFloat) convertCanvasHeight: (CGFloat)y ;
+(CGFloat) convertCanvasWidth: (CGFloat)x ;
+(CGFloat) convertCanvasY: (CGFloat)y ;
+(CGFloat) convertCanvasX: (CGFloat)x ;

@end
