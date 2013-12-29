#import "ShadowExecutor.h"

// _Helper.h
#import "ColorHelper.h"

@implementation ShadowExecutor

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UIView class]]){
        UIView* view = (UIView*)object;
        
        float OffsetX = [[config objectForKey: @"Offset.x"] floatValue];
        float OffsetY = [[config objectForKey: @"Offset.y"] floatValue];
        float radius = [[config objectForKey: @"Radius"] floatValue];
        float opacity = [[config objectForKey: @"Opacity"] floatValue] ;
        
        NSDictionary* colors = [config objectForKey: @"COLOR"];
        view.layer.shadowColor = [[ColorHelper parseColor: colors] CGColor];
        view.layer.shadowOffset = CGSizeMake(OffsetX, OffsetY);
        view.layer.shadowRadius = radius;
        view.layer.shadowOpacity = opacity;
    }
}

@end
