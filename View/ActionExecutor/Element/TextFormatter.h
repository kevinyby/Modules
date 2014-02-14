#import "ActionExecutorBase.h"

// label
#define JSON_FONT_NAME              @"FONT_NAME"
#define JSON_FONT_SIZE              @"FONT_SIZE"

#define JSON_FONT_BOLD              @"JS_FONT_BOLD"
#define JSON_FONT_ITALIC            @"JS_FONT_ITALIC"

#define JSON_FONT_N_COLOR           @"JS_FONT_N_COLOR"        // Normal Color
#define JSON_FONT_H_COLOR           @"JS_FONT_H_COLOR"        // Highlit Color
#define JSON_FONT_S_COLOR           @"JS_FONT_S_COLOR"        // Shadow Color


// -- StrokeLabel
#define JSON_STROKE_MODE            @"STROKE.mode"
#define JSON_STROKE_WIDTH           @"STROKE.width"
#define JSON_STROKE_COLOR           @"STROKE.color"


// -- GradientLabel
#define JSON_GRADIENT_COUNT         @"GRADIENT.count"

#define JSON_GRADIENT_ENDCOLOR      @"GRADIENT.endColor"
#define JSON_GRADIENT_STARTCOLOR    @"GRADIENT.startColor"

#define JSON_GRADIENT_ENDPOINT      @"GRADIENT.endPoint"
#define JSON_GRADIENT_STARTPOINT    @"GRADIENT.startPoint"

@interface TextFormatter : ActionExecutorBase

@end
