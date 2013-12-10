#import "TextFormatter.h"

// _View.h -> _Components.h -> _Label.h
#import "GradientLabel.h"

@implementation TextFormatter

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UILabel class]]){
        UILabel* label = (UILabel*)object;
        NSString* fontName = [config objectForKey: @"FACE"];
        NSDictionary* colors = [config objectForKey: @"COLOR"];
        
        float R, G, B , alpha;
        [self parseColor: colors red:&R green:&G blue:&B alpha:&alpha];
        
        float align = [[config objectForKey: @"ALIGN"] floatValue];
        float size = [[config objectForKey: @"SIZE"] floatValue] ;
        float rotate = [[config objectForKey: @"Rotate"] floatValue];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName: fontName size:size];
        label.textColor = [UIColor colorWithRed: R green:G blue:B alpha:alpha];
        CGRect rect = label.bounds;
        [label setFrame: CGRectMake(rect.origin.x + align, rect.origin.y, rect.size.width, rect.size.height)];
        label.transform = CGAffineTransformRotate(label.transform, rotate / 100.0);
        
        [label isKindOfClass: [StrokeLabel class]] ?
        [self applyStroke: config onObject:(StrokeLabel*)label] ,
        [label isKindOfClass: [GradientLabel class]] ?
        [self applyGradient: config onObject:(GradientLabel*)label] : nil : nil;
        
        [label setNeedsDisplay];
    }
}

-(void) applyStroke: (NSDictionary*)config onObject:(StrokeLabel*)object {
    NSNumber* drawinModeNum = [config objectForKey: @"STROKE.MODE"] ;
    CGTextDrawingMode drawingMode = drawinModeNum ? [drawinModeNum intValue] : kCGTextStroke ;
    object.drawingMode = drawingMode;
    
    NSNumber* widthNum = [config objectForKey: @"STROKE.WIDTH"] ;
    float width = widthNum ? [widthNum floatValue] : 1 ;
    object.width = width;
    
    NSDictionary* colors = [config objectForKey: @"STROKE.COLOR"];
    if (colors) {
        float red, green, blue, alpha;
        [self parseColor: colors red:&red green:&green blue:&blue alpha:&alpha];
        object.red = red, object.green = green, object.blue = blue , object.alpha = alpha;
    }
}

-(void) applyGradient: (NSDictionary*)config onObject:(GradientLabel*)object {
    NSDictionary* gradientDic = [config objectForKey: @"GRADIENT"];
    NSNumber* countNum = [gradientDic objectForKey: @"Point.Count"];
    object.gradientCount = countNum ? [countNum intValue] : 2 ;
    
    NSDictionary* colors = [gradientDic objectForKey: @"Color.Start"];
    if (colors) {
        float red, green, blue, alpha;
        [self parseColor: colors red:&red green:&green blue:&blue alpha:&alpha];
        object.gradientStartR = red, object.gradientStartG = green, object.gradientStartB = blue , object.gradientStartAlpah = alpha;
    }
    
    colors = [gradientDic objectForKey: @"Color.End"];
    if (colors) {
        float red, green, blue, alpha;
        [self parseColor: colors red:&red green:&green blue:&blue alpha:&alpha];
        object.gradientEndR = red, object.gradientEndG = green, object.gradientEndB = blue , object.gradientEndAlpah = alpha;
    }
    
    NSDictionary* point = [gradientDic objectForKey: @"Point.Start"];
    object.gradientStartPointX = [[point objectForKey: @"X"] floatValue];
    object.gradientStartPointY = [[point objectForKey: @"Y"] floatValue];
    point = [gradientDic objectForKey: @"Point.End"];
    object.gradientEndPointX = [[point objectForKey: @"X"] floatValue];
    object.gradientEndPointY = [[point objectForKey: @"Y"] floatValue];
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
