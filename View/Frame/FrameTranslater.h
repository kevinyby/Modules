#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject

+(CGSize) getPortraitCanvasSize ;
+(CGSize) setLandscapeCanvasSize ;
+(void) setPortraitCanvasSize: (CGSize)size ;
+(void) setLandscapeCanvasSize: (CGSize)size ;

+(void) setRealFrame: (UIInterfaceOrientation)orientation isRotate:(BOOL)isRotate view:(UIView*)view parameters:(NSDictionary*)parameters ;

+(CGRect)getRotateCanvasFrame: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame ;

+(NSValue*) getFrameValue: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame ;
+(CGRect) getFrame: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame ;

+(void) adjustLabelSize: (UILabel*)label orientation:(UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame text:(NSString*)text ;

@end
