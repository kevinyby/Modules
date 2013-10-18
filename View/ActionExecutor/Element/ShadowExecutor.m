#import "ShadowExecutor.h"

@implementation ShadowExecutor

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UIView class]]){
        UIView* view = (UIView*)object;
        NSDictionary* colors = [config objectForKey: @"COLOR"];
       
        float R, G, B , alpha;
        [self parseColor: colors red:&R green:&G blue:&B alpha:&alpha];
        
        float OffsetX = [[config objectForKey: @"Offset.x"] floatValue];
        float OffsetY = [[config objectForKey: @"Offset.y"] floatValue];
        float radius = [[config objectForKey: @"Radius"] floatValue];
        float opacity = [[config objectForKey: @"Opacity"] floatValue] ;
        
        view.layer.shadowColor = [[UIColor colorWithRed: R green:G blue:B alpha:alpha] CGColor];
        view.layer.shadowOffset = CGSizeMake(OffsetX, OffsetY);
        view.layer.shadowRadius = radius;
        view.layer.shadowOpacity = opacity;
    }
}

-(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha  {  // config - dic or array , same as TextRormatter
    *red = 0.0 , *green = 0.0, *blue = 0.0, *alpha = 1.0;
    if ([config isKindOfClass: [NSDictionary class]]) {
        *red = [[config objectForKey: @"R"] floatValue] ;
        *green = [[config objectForKey: @"G"] floatValue] ;
        *blue = [[config objectForKey: @"B"] floatValue] ;
        NSNumber* alphaNum = [config objectForKey: @"alpha"];
        if (alphaNum) *alpha = [alphaNum floatValue];
    } else if ([config isKindOfClass: [NSArray class]]) {
        for (int i = 0 ; i < [config count]; i++ ) {
            if (i == 0) *red = [[config objectAtIndex: i] floatValue];
            if (i == 1) *green = [[config objectAtIndex: i] floatValue];
            if (i == 2) *blue = [[config objectAtIndex: i] floatValue];
            if (i == 3) *alpha = [[config objectAtIndex: i] floatValue];
        }
    }
    *red = *red > 1.0 ? *red/255.0 : *red,  *green = *green > 1.0 ? *green/255.0 : *green,  *blue = *blue > 1.0 ? *blue/255.0 : *blue;
}

@end
