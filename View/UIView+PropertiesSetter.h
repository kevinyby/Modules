@interface UIView (PropertiesSetter)


- (void)setCenterX: (CGFloat)x;
- (void)setCenterY: (CGFloat)y;

#pragma mark - Size
- (CGFloat)getSizeWidth;
- (CGFloat)getSizeHeight;

- (void)setSizeWidth: (CGFloat)width;
- (void)setSizeHeight: (CGFloat)height;

#pragma mark - Origin

- (CGFloat)getOriginX;
- (CGFloat)getOriginY;

- (void)setOriginX: (CGFloat)x;
- (void)setOriginY: (CGFloat)y;

- (void)addOriginX: (CGFloat)x;
- (void)addOriginY: (CGFloat)y;

-(void) setOrigin: (CGPoint)point;

@end
