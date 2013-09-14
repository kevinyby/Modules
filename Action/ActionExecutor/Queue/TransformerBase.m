#import "TransformerBase.h"

@implementation TransformerBase

-(id) getEasingValue: (NSArray*)values index:(int)index nextIndex:(int)nextIndex argument:(double)argument {
    double currentDoubleVal = [[values objectAtIndex: index] doubleValue];
    double nextDoubleVal = [[values objectAtIndex: nextIndex] doubleValue];
    
    double newValue = currentDoubleVal + (nextDoubleVal - currentDoubleVal) * argument;
    return [NSNumber numberWithDouble: newValue];
}

-(void) applyForwardWith: (id)forwardNum animation:(CAKeyframeAnimation*)animation view:(UIView*)view {
    BOOL isForward = forwardNum ? [forwardNum boolValue] : NO;     // application default is NO
    if (isForward) {
        animation.removedOnCompletion = NO;         // IOS default is YES
        animation.fillMode = kCAFillModeForwards ;  // IOS default is kCAFillModeRemoved
    }
}

@end
