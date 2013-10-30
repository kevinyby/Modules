#import "BorderHelper.h"

@implementation BorderHelper


+(void) setBorder: (UIView*)view {
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [[UIColor greenColor] CGColor];
}

@end
