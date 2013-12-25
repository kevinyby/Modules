#import "ColorHelper.h"

#import "UIColor+FlatColors.h"

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
    float x = 0 , y = 0;
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



#pragma mark - 
#pragma mark - Convenient Methods

+(void) setBorderRecursive: (UIView*)view
{
    for (UIView* subview in view.subviews) {
        [ColorHelper setBorderRecursive: subview];
    }
    [ColorHelper setBorder: view];
}

+(void) clearBorderRecursive: (UIView*)view
{
    for (UIView* subview in view.subviews) {
        [ColorHelper clearBorderRecursive: subview];
    }
    [ColorHelper clearBorder: view];
}

+(void) setBorder: (UIView*)view
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [[UIColor greenColor] CGColor];
}

+(void) clearBorder: (UIView*)view
{
    view.layer.borderWidth = 0.0f;
    view.layer.borderColor = [[UIColor clearColor] CGColor];
}

+(void) setBorder: (UIView*)view color:(UIColor*)color
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [color CGColor];
}

+(void) setBorder: (UIView*)view colorIndex:(int)index
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [[ColorHelper color:index] CGColor];
}

+(void) setBackGround: (UIView*)view
{
    view.backgroundColor = [UIColor yellowColor];
}

+(void) setBackGround: (UIView*)view color:(UIColor*)color
{
    view.backgroundColor = color;
}

+(UIColor*) color: (int)chosenColor
{
    UIColor *color;
    switch (chosenColor) {
        case 0:
            color = [UIColor flatRedColor];
            break;
        case 1:
            color = [UIColor flatGreenColor];
            break;
        case 2:
            color = [UIColor flatBlueColor];
            break;
        case 3:
            color = [UIColor flatTealColor];
            break;
        case 4:
            color = [UIColor flatPurpleColor];
            break;
        case 5:
            color = [UIColor flatYellowColor];
            break;
        case 6:
            color = [UIColor flatOrangeColor];
            break;
        case 7:
            color = [UIColor flatGrayColor];
            break;
        case 8:
            color = [UIColor flatWhiteColor];
            break;
        case 9:
            color = [UIColor flatBlackColor];
            break;
        case 10:
            color = [UIColor flatDarkRedColor];
            break;
        case 11:
            color = [UIColor flatDarkGreenColor];
            break;
        case 12:
            color = [UIColor flatDarkBlueColor];
            break;
        case 13:
            color = [UIColor flatDarkTealColor];
            break;
        case 14:
            color = [UIColor flatDarkPurpleColor];
            break;
        case 15:
            color = [UIColor flatDarkYellowColor];
            break;
        case 16:
            color = [UIColor flatDarkOrangeColor];
            break;
        case 17:
            color = [UIColor flatDarkGrayColor];
            break;
        case 18:
            color = [UIColor flatDarkWhiteColor];
            break;
        case 19:
            color = [UIColor flatDarkBlackColor];
            break;
        case 20:
        default:
            NSAssert(0, @"Unrecognized color selected as random color");
            break;
    }
    return color;
}

@end
