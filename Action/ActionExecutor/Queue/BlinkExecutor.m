#import "BlinkExecutor.h"

@implementation BlinkExecutor

-(void) applyKeyPath: (CAKeyframeAnimation*)animation {
    animation.keyPath = @"opacity" ;
}

@end
