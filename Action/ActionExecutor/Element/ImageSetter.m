#import "ImageSetter.h"

@implementation ImageSetter

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UIView class]]){
        UIView* view = (UIView*)object;
        NSNumber* alphaNumber = [config objectForKey: @"alpha"];
        NSNumber* scaleNumber = [config objectForKey: @"scale"];
        float alpha = (alphaNumber) ? [alphaNumber floatValue] : 1.0 ;
        float scale = (scaleNumber) ? [scaleNumber floatValue] : 1.0 ;
        
        if (alpha != 1.0 || scale != 1.0) {
            view.alpha = alpha ;
            view.transform = CGAffineTransformMakeScale(scale, scale);
        } else {
            view.alpha = 1.0;
            view.transform = CGAffineTransformIdentity;
        }
    }
}

@end
