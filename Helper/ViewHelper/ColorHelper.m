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

+(UIColor*) parseColor: (id)config {
    if (! config) return nil;
    if (! ([config isKindOfClass: [NSArray class]] || [config isKindOfClass: [NSDictionary class]])) return nil;
    
    float red = 0.0, green = 0.0, blue = 0.0 ,alpha = 1.0;
    [self parseColor: config red:&red green:&green blue:&blue alpha:&alpha];
    return [UIColor colorWithRed: red green:green blue:blue alpha:alpha] ;
}

// config - dic or array
+(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha
{
    *red = 0.0 , *green = 0.0, *blue = 0.0, *alpha = 1.0;
    if ([config isKindOfClass: [NSDictionary class]]) {
        *red = [[config objectForKey:   @"R"] floatValue] ;
        *green = [[config objectForKey: @"G"] floatValue] ;
        *blue = [[config objectForKey:  @"B"] floatValue] ;
        NSNumber* alphaNum = [config objectForKey:  @"alpha"];
        if (alphaNum) *alpha = [alphaNum floatValue];
    } else if ([config isKindOfClass: [NSArray class]]) {
        for (int i = 0 ; i < [config count]; i++ ) {
            if (i == 0) *red = [[config objectAtIndex: i] floatValue];
            else
            if (i == 1) *green = [[config objectAtIndex: i] floatValue];
            else
            if (i == 2) *blue = [[config objectAtIndex: i] floatValue];
            else
            if (i == 3) *alpha = [[config objectAtIndex: i] floatValue];
        }
    }
    *red = *red > 1.0 ? *red/255.0 : *red,  *green = *green > 1.0 ? *green/255.0 : *green,  *blue = *blue > 1.0 ? *blue/255.0 : *blue;
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


+(void) clearBorder: (UIView*)view
{
    view.layer.borderWidth = 0.0f;
    view.layer.borderColor = [[UIColor clearColor] CGColor];
}






+(void) setBorder: (UIView*)view
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [[UIColor greenColor] CGColor];
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
    view.backgroundColor = [UIColor greenColor];
}
+(void) setBackGround: (UIView*)view color:(UIColor*)color
{
    view.backgroundColor = color;
}
+(void) setBackGround: (UIView*)view colorIndex:(int)index
{
    view.backgroundColor = [ColorHelper color:index];
}

+(UIColor*) color: (int)chosenColor
{
    UIColor *color;
    switch (chosenColor) {
        case 0:
            color = [UIColor clearColor]; // 0.0 white, 0.0 alpha
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
            color = [UIColor flatRedColor];
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
            color = [UIColor flatDarkRedColor];
            break;
            
            
            
        case 21:
            color = [UIColor darkGrayColor]; // 0.333 white
            break;
        case 22:
            color = [UIColor lightGrayColor]; // 0.667 white
            break;
        case 23:
            color = [UIColor whiteColor]; // 1.0 white
            break;
        case 24:
            color = [UIColor grayColor]; // 0.5 white
            break;
        case 25:
            color = [UIColor redColor]; // 1.0, 0.0, 0.0 RGB
            break;
        case 26:
            color = [UIColor greenColor]; // 0.0, 1.0, 0.0 RGB
            break;
        case 27:
            color = [UIColor blueColor]; // 0.0, 0.0, 1.0 RGB
            break;
        case 28:
            color = [UIColor cyanColor]; // 0.0, 1.0, 1.0 RGB
            break;
        case 29:
            color = [UIColor yellowColor]; // 1.0, 1.0, 0.0 RGB
            break;
        case 30:
            color = [UIColor magentaColor]; // 1.0, 0.0, 1.0 RGB
            break;
        case 31:
            color = [UIColor orangeColor]; // 1.0, 0.5, 0.0 RGB
            break;
        case 32:
            color = [UIColor purpleColor]; // 0.5, 0.0, 0.5 RGB
            break;
        case 33:
            color = [UIColor brownColor]; // 0.6, 0.4, 0.2 RGB
            break;
        case 34:
            color = [UIColor blackColor]; // 0.0 white
            break;
            
        default:
            
//            NSAssert(0, @"Unrecognized color selected as random color");
            break;
    }
    return color;
}

@end
