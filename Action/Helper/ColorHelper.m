#import "ColorHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorHelper

#pragma mark - Touch Methods
+(void) applyGradient: (UIImageView*)view config:(NSDictionary*)config flag:(BOOL*)flag {
    CAGradientLayer* gradient = [self assembleGradientLayer: config];
    if (*flag) {
        CALayer* layer = [[[view layer] sublayers] objectAtIndex: 0];
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
            *flag = NO;
        }
    }
    if (!view.image && gradient && !*flag) {
        [[view layer] insertSublayer:gradient atIndex:0];
        gradient.frame = [[UIScreen mainScreen] bounds];
        *flag = YES;
    }
}
#pragma mark - Public Methods
+(CAGradientLayer*) assembleGradientLayer: (NSDictionary*)config {
    if (config) {
        CAGradientLayer* gradient = [CAGradientLayer layer];
        gradient.cornerRadius = [[config objectForKey: @"Corner.Radius"] intValue];
        
        // colors
        NSArray* colors = nil;
        id colorStart = [config objectForKey: @"Color.Start"];
        id colorEnd = [config objectForKey: @"Color.End"];
        if( colorStart && colorEnd ) {
            colors = [NSArray arrayWithObjects:
                      (id)[self parseColor:[config objectForKey: @"Color.Start"]].CGColor,
                      (id)[self parseColor:[config objectForKey: @"Color.End"]].CGColor, nil];
        } else {
            colors = [config objectForKey: @"Colors"];
        }
        gradient.colors = colors;
        
        // locations
        id startPoint = [config objectForKey: @"Point.Start"];
        id endPoint = [config objectForKey: @"Point.End"];
        gradient.locations = [config objectForKey: @"Locations"];
        if (startPoint && endPoint) {
            gradient.startPoint = [self parseGradientPoint: startPoint];
            gradient.endPoint = [self parseGradientPoint: endPoint];
        }
        return gradient;
    }
    return nil;
}

+(UIColor*) parseColor: (id)config {  // config - dic or array
    float red = 0.0, green = 0.0, blue = 0.0 ,alpha = 1.0;
    if ([config isKindOfClass: [NSDictionary class]]) {
        red = [[config objectForKey: @"R"] floatValue] ;
        green = [[config objectForKey: @"G"] floatValue] ;
        blue = [[config objectForKey: @"B"] floatValue] ;
        NSNumber* alphaNum = [config objectForKey: @"alpha"];
        if (alphaNum) alpha = [alphaNum floatValue];
    } else if ([config isKindOfClass: [NSArray class]]) {
        for (int i = 0 ; i < [config count]; i++ ) {
            if (i == 0) red = [[config objectAtIndex: i] floatValue];
            if (i == 1) green = [[config objectAtIndex: i] floatValue];
            if (i == 2) blue = [[config objectAtIndex: i] floatValue];
            if (i == 3) alpha = [[config objectAtIndex: i] floatValue];
        }
    }
    return config ? [UIColor colorWithRed: red green:green blue:blue alpha:alpha] : nil;
}

+(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha {  // config - dic or array
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
}

#pragma mark - Private Methods
+(CGPoint) parseGradientPoint: (id)config {
    float x , y ;
    if ([config isKindOfClass:[NSDictionary class]]) {
        x = [[config objectForKey: @"X"] floatValue];
        y = [[config objectForKey: @"Y"] floatValue];
    } else if ([config isKindOfClass: [NSArray class]]) {
        for (int i = 0 ; i < [config count]; i++ ) {
            if (i == 0) x = [[config objectAtIndex: i] floatValue];
            if (i == 1) y = [[config objectAtIndex: i] floatValue];
        }
    }
    return CGPointMake(x, y);
}

@end
