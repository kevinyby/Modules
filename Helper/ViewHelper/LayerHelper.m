#import "LayerHelper.h"

@implementation LayerHelper

+(void) setAnchorPoint:(CGPoint)anchorpoint forLayer:(CALayer*)layer
{
    CGRect oldFrame = layer.frame;
    layer.anchorPoint = anchorpoint;
    layer.frame = oldFrame;
}

@end
