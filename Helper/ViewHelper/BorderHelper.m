#import "BorderHelper.h"

@implementation BorderHelper


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

@end
