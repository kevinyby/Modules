@interface UIView (PropertiesSetter)


- (void)setCenterX: (CGFloat)x;
- (void)setCenterY: (CGFloat)y;

- (CGFloat)getSizeWidth;
- (CGFloat)getSizeHeight;
- (void)setSizeWidth: (CGFloat)width;
- (void)setSizeHeight: (CGFloat)height;

- (CGFloat)getOriginX;
- (CGFloat)getOriginY;
- (void)setOriginX: (CGFloat)x;
- (void)setOriginY: (CGFloat)y;

- (void)addOriginX: (CGFloat)x;
- (void)addOriginY: (CGFloat)y;

@end
