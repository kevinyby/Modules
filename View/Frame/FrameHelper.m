#import "FrameHelper.h"

#import "FrameTranslater.h"
#import "UIWiew+CanvasFrame.h"

@implementation FrameHelper

+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.canvasFrame = [self getFrameValue: canvas];
    view.rotateCanvasFrame = [self getRotateFrameValue: canvas];
}


+(NSValue*) getFrameValue: (CGRect)canvas {
    return [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
}

+(NSValue*) getRotateFrameValue: (CGRect)canvas {
    return [NSValue valueWithCGRect: [FrameTranslater getFrame:[FrameTranslater getRotateCanvasFrame: canvas]]];
}

@end
