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

- (void)setSizeWidth: (CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setSizeHeight: (CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

@end
