#import "UIView+PropertiesSetter.h"

@implementation UIView (PropertiesSetter)


#pragma mark - Center
- (void)setCenterX: (CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}

- (void)setCenterY: (CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}

- (CGFloat)getCenterX
{
    return self.center.x;
}

- (CGFloat)getCenterY
{
    return self.center.y;
}


-(CGPoint) getMiddlePoint
{
    return CGPointMake([self getSizeWidth]/2, [self getSizeHeight]/2);
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

- (CGSize)getSize
{
	return self.frame.size;
}

- (void)setSize: (CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}


- (void)addSizeWidth: (CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width += width;
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

- (void)minusOriginX: (CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x -= x;
	self.frame = frame;
}

- (void)minusOriginY: (CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y -= y;
	self.frame = frame;
}

-(void) setOrigin: (CGPoint)point
{
    CGRect frame = self.frame;
	frame.origin = point;
	self.frame = frame;
}

-(CGPoint) getOrigin
{
    return self.frame.origin;
}

@end
