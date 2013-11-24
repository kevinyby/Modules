#import "FrameHelper.h"
#import "FrameTranslater.h"
#import "UIWiew+CanvasFrame.h"

@implementation FrameHelper

static Boolean isNeedReserve ;

+(void)initialize {
    [super initialize];
    isNeedReserve = YES;
}

+(Boolean) isNeedReserve {
    return isNeedReserve;
}

+(void) isNeedReserve: (Boolean)isNeed {
    isNeedReserve = isNeed;
}


+(void) setFrame: (CGRect)canvas view:(UIView*)view {
    [self translateCanvas: canvas view:view];
    view.frame = [view.actualFrame CGRectValue];
}

+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.actualFrame = [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
    if (isNeedReserve) view.designFrame = [NSValue valueWithCGRect: canvas];
}

+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas
{
    [FrameTranslater transformLabel: label canvas: canvas];
}

@end
