#import "UIView+PropertiesSetter.h"

@implementation UIView (PropertiesSetter)

- (void)setCenterX: (CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}

- (void)setCenterY: (CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}

@end
