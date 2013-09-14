#import "FrameHelper.h"

#import "FrameTranslater.h"
#import "UIWiew+CanvasFrame.h"

@implementation FrameHelper

+(void) setFrame: (CGRect)canvas view:(UIView*)view {
    [self translateCanvas: canvas view:view];
    view.frame = [view.canvasFrame CGRectValue];
}

+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.designFrame = [NSValue valueWithCGRect: canvas];
    view.canvasFrame = [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
    view.rotateCanvasFrame = [NSValue valueWithCGRect: [FrameTranslater getFrame: [self getRotateCanvas: canvas]]];
}

+(void) setFrameByOrientation: (UIInterfaceOrientation)interfaceOrientation view:(UIView*)view {   // first call translateCanvas:view:
    view.frame = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? [view.canvasFrame CGRectValue] : [view.rotateCanvasFrame CGRectValue];
}

+(void) translateFontLabel: (UILabel*)label {         // first call translateCanvas:view:
    CGRect canvas = [label.designFrame CGRectValue];
    [FrameTranslater adjustLabelSize: label canvasFrame: canvas];
}


#pragma mark - About Frame
+(CGRect)getRotateCanvas: (CGRect)canvas {
    BOOL isPortrait = [FrameTranslater isPortraitDesigned];
    
    CGRect frame = canvas;
    
    CGSize portraitCanvasSize = [FrameTranslater getPortraitCanvasSize];
    CGSize landscapeCanvasSize = [FrameTranslater getLandscapeCanvasSize];
    
    CGSize fromCanvas = (isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    CGSize toCanvas = (!isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    
    float ratioHorizontal = toCanvas.width / fromCanvas.width;
    float ratioVertical = toCanvas.height/ fromCanvas.height;
    
    frame.origin.x *= ratioHorizontal;
    frame.origin.y *= ratioVertical;
    
    float targetWidth = frame.size.width * ratioHorizontal;
    float targetHeight = frame.size.height * ratioVertical;
    
    float minusWidth = targetWidth - frame.size.width ;
    float minusHeight = targetHeight - frame.size.height ;
    
    frame.origin.x += minusWidth/2;
    frame.origin.y += minusHeight/2;
    
    return frame;
    
}

@end
