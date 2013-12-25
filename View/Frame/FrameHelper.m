#import "FrameHelper.h"

#import "FrameTranslater.h"

#import "FrameManager.h"

#import "UIWiew+CanvasFrame.h"

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
    
    view.actualFrame = [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
    view.frame = [view.actualFrame CGRectValue];
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
    [FrameTranslater transformLabel: label];
    label.frame = [FrameTranslater getFrame: canvas ];
}




+(void) setComponentFrame: (NSArray*)frame component:(UIView*)view
{
    if (frame.count != 4) return;
    
    float ingore_value = -1.1f;
    
    float x = [frame[0] floatValue];
    float y = [frame[1] floatValue];
    float width = [frame[2] floatValue];
    float height = [frame[3] floatValue];
    
    bool isIgnoreX      = x         == ingore_value;
    bool isIgnoreY      = y         == ingore_value;
    bool isIgnoreWidth  = width     == ingore_value;
    bool isIgnoreHeight = height    == ingore_value;
    
    if ( !isIgnoreX && !isIgnoreY && !isIgnoreWidth && !isIgnoreHeight){
        
        CGRect canvas = [ArrayHelper convertToRect: frame];
        [FrameHelper setFrame: canvas view:view];
        
    } else {
        if (!isIgnoreX) [view setOriginX:[FrameTranslater convertCanvasX:x]];
        if (!isIgnoreY) [view setOriginY:[FrameTranslater convertCanvasY:y]];
        if (!isIgnoreWidth) [view setSizeWidth: [FrameTranslater convertCanvasWidth: width]];
        if (!isIgnoreHeight) [view setSizeHeight: [FrameTranslater convertCanvasHeight: height]];
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
 i.e.
 {
 "GameView" : {
 "HeaderView": [50, 20, 900, 100],
 "ContainerView": [50, 150, 900, 550],
 "HeaderView+" : {
 "UILabel0" : [0,0, 100, 50],
 "UILabel1" : [200,0, 100, 50]
 }
 }
 }
 */
+(void) setSubViewsFrames: (UIView*)view config:(NSDictionary*)config
{
    NSArray* subviews = [view subviews];
    for (UIView* subview in subviews) {
        // get rect array
        NSString* key = NSStringFromClass([subview class]);
        NSArray* rectArray = config[key];
        if (!rectArray) {
            int index = [subviews indexOfObject: subview];
            NSString* realKey = [key stringByAppendingFormat:@"%d", index];
            rectArray = config[realKey];
        }
        
        // rect array to cgrect
        CGRect rect = [ArrayHelper convertToRect: rectArray];
        [FrameHelper setFrame: rect view:subview];
        //        [BorderHelper setBorder: subview];
        
        // recursively set subviews frames
        NSString* subKey = [key stringByAppendingString:@"+"];
        NSDictionary* subConfig = config[subKey];
        [self setSubViewsFrames: subview config:subConfig];
    }
}


// deprecated
+(void) translateCanvas: (CGRect)canvas view:(UIView*)view {
    view.actualFrame = [NSValue valueWithCGRect: [FrameTranslater getFrame: canvas]];
    if (isNeedReserve) view.designFrame = [NSValue valueWithCGRect: canvas];
}


@end
