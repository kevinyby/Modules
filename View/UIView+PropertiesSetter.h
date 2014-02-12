@interface UIView (PropertiesSetter)


- (void)setCenterX: (CGFloat)x;
- (void)setCenterY: (CGFloat)y;
- (CGFloat)getCenterX;
- (CGFloat)getCenterY;

-(void) addCenterX:(CGFloat)x;
-(void) addCenterY:(CGFloat)y;

-(CGPoint) getMiddlePoint;

#pragma mark - Size
- (CGFloat)getSizeWidth;
- (CGFloat)getSizeHeight;

- (void)setSizeWidth: (CGFloat)width;
- (void)setSizeHeight: (CGFloat)height;

- (CGSize)getSize;
- (void)setSize: (CGSize)size;

- (void)addSizeWidth: (CGFloat)width;

#pragma mark - Origin

- (CGFloat)getOriginX;
- (CGFloat)getOriginY;

- (void)setOriginX: (CGFloat)x;
- (void)setOriginY: (CGFloat)y;

- (void)addOriginX: (CGFloat)x;
- (void)addOriginY: (CGFloat)y;
- (void)minusOriginX: (CGFloat)x;
- (void)minusOriginY: (CGFloat)y;

-(CGPoint) getOrigin;
-(void) setOrigin: (CGPoint)point;

@end
