#import "ImageAnimator.h"

@implementation ImageAnimator

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UIImageView class]]){
        UIImageView* imageView = (UIImageView*)object;
        NSNumber* duration = [config objectForKey: @"duration"] ;
        NSNumber* repeatCount = [config objectForKey: @"repeatCount"] ;
        
        imageView.animationDuration = (duration) ? [duration floatValue] : 0.05 ;
        imageView.animationRepeatCount = (repeatCount) ? [repeatCount intValue] : 1;   // if is "0" , it will repeat all the times
        [imageView startAnimating];
    } 
}

@end
