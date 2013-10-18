#import "BeatExecutor.h"

@implementation BeatExecutor

-(void) applyKeyPath: (CAKeyframeAnimation*)animation {
    animation.keyPath = @"transform.scale" ;
}

@end
