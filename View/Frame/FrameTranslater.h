#import <Foundation/Foundation.h>

@interface FrameTranslater : NSObject


+(void) setPortraitCanvasRect: (CGSize)size ;

+(void) setLandscapeCanvasRect: (CGSize)size ;

+(CGRect) getFrame: (UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame parameters:(NSDictionary*)parameters ;

+(CGRect) convertFrame: (CGRect)canvasFrame orientation:(UIInterfaceOrientation)orientation ;

+(CGRect) getDeviceRect: (UIInterfaceOrientation) orientation ;

+(void) adjustLabelSize: (UILabel*)label orientation:(UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame text:(NSString*)text ;
    
@end
