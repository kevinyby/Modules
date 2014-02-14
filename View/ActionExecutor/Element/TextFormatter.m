#import "TextFormatter.h"

#import "FontHelper.h"
#import "ColorHelper.h"

// _View.h -> _Components.h -> _Label.h
#import "StrokeLabel.h"
#import "GradientLabel.h"

@implementation TextFormatter

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UILabel class]]){
        UILabel* label = (UILabel*)object;
        
        
        // font
        NSString* fontName = [config objectForKey: JSON_FONT_NAME];
        float fontSize = [[config objectForKey: JSON_FONT_SIZE] floatValue];
        fontSize = fontSize == 0 ? [UIFont labelFontSize] : fontSize;
        
        UIFont* font = [UIFont fontWithName: fontName size:fontSize];
        font = font ? font : [UIFont systemFontOfSize: [UIFont labelFontSize]];
        label.font = font;
        
        
        // color
        label.textColor = [ColorHelper parseColor: config[JSON_FONT_N_COLOR]];
        label.shadowColor = [ColorHelper parseColor: config[JSON_FONT_S_COLOR]];
        label.highlightedTextColor = [ColorHelper parseColor: config [JSON_FONT_H_COLOR]];
        
        // bold & italic
        BOOL fontBold = [[config objectForKey: JSON_FONT_BOLD] boolValue];
        BOOL fontItalic = [[config objectForKey: JSON_FONT_ITALIC] boolValue];
        if (fontBold) [FontHelper setBoldToFont: label];
        if (fontItalic) [FontHelper setItalicToFont: label];
        
        // StrokeLabel & GradientLabel
        [label isKindOfClass: [StrokeLabel class]] ?
        [self applyStroke: config onObject:(StrokeLabel*)label] ,
        [label isKindOfClass: [GradientLabel class]] ?
        [self applyGradient: config onObject:(GradientLabel*)label] : nil : nil;
        
        [label setNeedsDisplay];
    }
}

#pragma mark - Private Methods

// StrokeLabel
-(void) applyStroke: (NSDictionary*)config onObject:(StrokeLabel*)label {
    NSNumber* drawinModeNum = [config objectForKey: JSON_STROKE_MODE] ;
    CGTextDrawingMode drawingMode = drawinModeNum ? [drawinModeNum intValue] : kCGTextStroke ;
    label.drawingMode = drawingMode;
    
    label.strokeWidth = [[config objectForKey: JSON_STROKE_WIDTH] floatValue];
    
    NSDictionary* colors = [config objectForKey: JSON_STROKE_COLOR];
    float red, green, blue, alpha;
    [ColorHelper parseColor: colors red:&red green:&green blue:&blue alpha:&alpha];
    label.strokeR = red, label.strokeG = green, label.strokeB = blue , label.strokeAlpha = alpha;
}

// GradientLabel
-(void) applyGradient: (NSDictionary*)config onObject:(GradientLabel*)label {
    NSNumber* countNum = [config objectForKey: JSON_GRADIENT_COUNT];
    label.gradientCount = [countNum intValue];
    
    float red, green, blue, alpha;
    
    id startcolors = [config objectForKey: JSON_GRADIENT_STARTCOLOR];
    [ColorHelper parseColor: startcolors red:&red green:&green blue:&blue alpha:&alpha];
    label.gradientStartR = red, label.gradientStartG = green, label.gradientStartB = blue , label.gradientStartAlpah = alpha;
    
    id endcolors = [config objectForKey: JSON_GRADIENT_STARTCOLOR];
    [ColorHelper parseColor: endcolors red:&red green:&green blue:&blue alpha:&alpha];
    label.gradientEndR = red, label.gradientEndG = green, label.gradientEndB = blue , label.gradientEndAlpah = alpha;
    
    NSArray* startpoint = [config objectForKey: JSON_GRADIENT_ENDPOINT];
    label.gradientStartPointX = [startpoint[0] floatValue];
    label.gradientStartPointY = [startpoint[1] floatValue];
    NSArray* endpoint = [config objectForKey: JSON_GRADIENT_STARTPOINT];
    label.gradientEndPointX = [endpoint[0] floatValue];
    label.gradientEndPointY = [endpoint[1] floatValue];
}

@end
