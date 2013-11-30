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

+(void) translateLabel:(UILabel *)label
{
    CGRect canvas = [label.designFrame CGRectValue];    // after label has design frame
    [FrameTranslater transformLabel: label canvas: canvas];
}

+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas
{
    [FrameTranslater transformLabel: label canvas: canvas];
}

// deprecated
+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.actualFrame = [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
    if (isNeedReserve) view.designFrame = [NSValue valueWithCGRect: canvas];
}


@end
