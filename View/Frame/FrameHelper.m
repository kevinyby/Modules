#import "FrameHelper.h"

#import "FrameTranslater.h"
#import "UIWiew+CanvasFrame.h"

@implementation FrameHelper

+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.canvasFrame = [self getFrameValue: canvas];
    view.rotateCanvasFrame = [self getRotateFrameValue: canvas];
}

+(void) setFrameByOrientation: (UIInterfaceOrientation)interfaceOrientation view:(UIView*)view {
    view.frame = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? [view.canvasFrame CGRectValue] : [view.rotateCanvasFrame CGRectValue];
}


+(NSValue*) getFrameValue: (CGRect)canvas {
    return [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
}

+(NSValue*) getRotateFrameValue: (CGRect)canvas {
    return [NSValue valueWithCGRect: [FrameTranslater getFrame:[FrameTranslater getRotateCanvasFrame: canvas]]];
}

@end
