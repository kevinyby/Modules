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

#pragma mark - Size

- (CGFloat)getSizeWidth
{
	CGRect frame = self.frame;
	return frame.size.width ;
}

- (CGFloat)getSizeHeight
{
	CGRect frame = self.frame;
	return frame.size.height ;
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

- (void)setSize: (CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

#pragma mark - Origin

- (CGFloat)getOriginX
{
    CGRect frame = self.frame;
    return frame.origin.x ;
}

- (CGFloat)getOriginY
{
    CGRect frame = self.frame;
    return frame.origin.y ;
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

- (void)addOriginX: (CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x += x;
	self.frame = frame;
}

- (void)addOriginY: (CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y += y;
	self.frame = frame;
}

-(void) setOrigin: (CGPoint)point
{
    CGRect frame = self.frame;
	frame.origin = point;
	self.frame = frame;
}

@end
