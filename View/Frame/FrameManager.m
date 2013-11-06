#import "FrameManager.h"
#import "FrameHelper.h"

@implementation FrameManager



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
        CGRect rect = [self convertToRect: rectArray];
        [FrameHelper setFrame: rect view:subview];
//        [BorderHelper setBorder: subview];
        
        // recursively set subviews frames
        NSString* subKey = [key stringByAppendingString:@"+"];
        NSDictionary* subConfig = config[subKey];
        [self setSubViewsFrames: subview config:subConfig];
    }
}

/** @prama rectArray @[@(0),@(0), @(200), @(50)] */
+(CGRect) convertToRect: (NSArray *)rectArray
{
    return CGRectMake([[rectArray objectAtIndex: 0] floatValue],
                      [[rectArray objectAtIndex: 1] floatValue],
                      [[rectArray objectAtIndex: 2] floatValue],
                      [[rectArray objectAtIndex: 3] floatValue]);
}

@end
