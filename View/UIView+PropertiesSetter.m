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


- (void)setOriginX: (CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (void)setOriginY: (CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

@end
