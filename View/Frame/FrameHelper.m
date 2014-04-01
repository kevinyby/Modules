#import "FrameHelper.h"

#import "FrameTranslater.h"

#import "UIView+CanvasFrame.h"

#import "UIView+PropertiesSetter.h"

#import "ArrayHelper.h"

@implementation FrameHelper

static Boolean isNeedReserve ;

+(void)initialize {
    [super initialize];
    isNeedReserve = YES;
}

+(Boolean) isNeedReserve {
    return isNeedReserve;
}

+(void) isNeedReserve: (Boolean)isNeed {
    isNeedReserve = isNeed;
}

+(void) setFrame: (CGRect)canvas view:(UIView*)view {
    if (isNeedReserve) view.designFrame = [NSValue valueWithCGRect: canvas];
    
    CGRect frame = [FrameTranslater convertCanvasRect: canvas];
    view.actualFrame = [NSValue valueWithCGRect: frame];
    view.frame = frame;
}

/**
 *
 *  Important, Font Size and Transform ,  choose one of them !!!
 *
 *  Both of them are need getFrame:
 *
 *  @param label The label you want to fit
 */

+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas
{
    [FrameTranslater transformView: label];
    label.frame = [FrameTranslater convertCanvasRect: canvas ];
}



// deprecated
+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.actualFrame = [NSValue valueWithCGRect: [FrameTranslater convertCanvasRect: canvas]];
    if (isNeedReserve) view.designFrame = [NSValue valueWithCGRect: canvas];
}


#pragma mark -

+(CGRect) getScreenRectByOrientation
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    float screenWidth = screenSize.size.width;
    float screenHeight = screenSize.size.height;
    UIViewController* controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIInterfaceOrientation orientation = controller.interfaceOrientation;
    CGRect rect = UIInterfaceOrientationIsPortrait(orientation) ? (CGRect){{0,0},{screenWidth,screenHeight}} : (CGRect){{0,0},{screenHeight,screenWidth}};
    return rect;
}

+(void) setComponentFrame: (NSArray*)values component:(UIView*)view
{
    float x = 0.0, y = 0.0, width = 0.0, height = 0.0;
    bool isIgnoreX = NO, isIgnoreY = NO, isIgnoreWidth = NO, isIgnoreHeight = NO;
    [self paseIgnores: values :&x :&y :&width :&height :&isIgnoreX :&isIgnoreY :&isIgnoreWidth :&isIgnoreHeight];
    
    if ( !isIgnoreX && !isIgnoreY && !isIgnoreWidth && !isIgnoreHeight){
        CGRect canvas = [ArrayHelper convertToRect: values];
        [FrameHelper setFrame: canvas view:view];
    } else {
        if (!isIgnoreX) [view setOriginX:[FrameTranslater convertCanvasX:x]];
        if (!isIgnoreY) [view setOriginY:[FrameTranslater convertCanvasY:y]];
        if (!isIgnoreWidth) [view setSizeWidth: [FrameTranslater convertCanvasWidth: width]];
        if (!isIgnoreHeight) [view setSizeHeight: [FrameTranslater convertCanvasHeight: height]];
    }
}

+(void) paseIgnores:(NSArray*)values :(float*)x :(float*)y :(float*)width :(float*)height :(bool*)isIgnoreX :(bool*)isIgnoreY :(bool*)isIgnoreWidth :(bool*)isIgnoreHeight
{
    float ingore_value = -1.1f;
    
    NSNumber* valueX = ((int)values.count - 1) < (int)0 ? nil : [values objectAtIndex: 0];
    NSNumber* valueY = ((int)values.count - 1) < (int)1 ? nil : [values objectAtIndex: 1];
    NSNumber* valueWidth = ((int)values.count - 1) < (int)2 ? nil : [values objectAtIndex: 2];
    NSNumber* valueHeight = ((int)values.count - 1) < (int)3 ? nil : [values objectAtIndex: 3];
    
    *x = [valueX floatValue];
    *y = [valueY floatValue];
    *width = [valueWidth floatValue];
    *height = [valueHeight floatValue];
    
    *isIgnoreX      = valueX == nil         || *x == ingore_value;
    *isIgnoreY      = valueY == nil         || *y == ingore_value;
    *isIgnoreWidth  = valueWidth  == nil    || *width == ingore_value;
    *isIgnoreHeight = valueHeight == nil    || *height == ingore_value;
}


+(void) setComponentCenter: (NSArray*)values component:(UIView*)view
{
    if (values.count != 2) return;
    
    float ingore_value = -1.1f;
    
    float x = [values[0] floatValue];
    float y = [values[1] floatValue];
    
    bool isIgnoreX      = x         == ingore_value;
    bool isIgnoreY      = y         == ingore_value;
    
    
    if ( !isIgnoreX && !isIgnoreY){
        CGPoint point = [ArrayHelper convertToPoint: values];
        CGPoint center = [FrameTranslater convertCanvasPoint: point];
        view.center = center;
        
    } else {
        if (!isIgnoreX) [view setCenterX:[FrameTranslater convertCanvasX:x]];
        if (!isIgnoreY) [view setCenterY:[FrameTranslater convertCanvasY:y]];
    }
    
}


+(UIEdgeInsets) convertCanvasEdgeInsets: (UIEdgeInsets)insets
{
    return UIEdgeInsetsMake([FrameTranslater convertCanvasHeight: insets.top],
                            [FrameTranslater convertCanvasWidth: insets.left],
                            [FrameTranslater convertCanvasHeight: insets.bottom],
                            [FrameTranslater convertCanvasWidth: insets.right]);
}


/**
 Convention :
 {
 "GameView" : {
    "SELF": [0, 0, 1024, 768],
    "HeaderView": [50, 20, 900, 100],
    "ContainerView": [50, 150, 900, 550],
 }
 }
 */
+(void) setSubViewsFrames: (UIView*)view config:(NSDictionary*)config
{
    if (!config) return;
    
    if (config[@"SELF"]) [FrameHelper setFrame: [ArrayHelper convertToRect: config[@"SELF"]] view:view];
    
    NSArray* subviews = [view subviews];
    for (UIView* subview in subviews) {
        // get rect array
        NSString* className = NSStringFromClass([subview class]);
        id values = config[className];
        
        if ([values isKindOfClass:[NSArray class]]) {
            [FrameHelper setFrame: [ArrayHelper convertToRect: (NSArray*)values] view:subview];
            
        } else if ([values isKindOfClass:[NSDictionary class]]) {
            // recursively set subviews frames
            [self setSubViewsFrames: subview config:(NSDictionary*)values];
            
        }
    }
}


@end
