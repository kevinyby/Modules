#import "ActionExecutorBase.h"


#define JSON_FONT_NAME              @"FONT_NAME"
#define JSON_FONT_SIZE              @"FONT_SIZE"
#define JSON_TEXT_COLOR             @"TEXT_COLOR"


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
