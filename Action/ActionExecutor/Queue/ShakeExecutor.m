#import "ShakeExecutor.h"

@implementation ShakeExecutor

-(void) applyKeyPath: (CAKeyframeAnimation*)animation {
    animation.keyPath = @"transform.rotation.z" ;
}

@end
