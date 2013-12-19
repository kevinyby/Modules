#import "ZoomablePanScrollView.h"

@implementation ZoomablePanScrollView
{
    float firstX;
    float firstY;
    
    float oCenterX;
    float oCenterY;
    
    float maxOffsetX;
    float maxOffsetY;
}

-(void) initializeVariables
{
    [super initializeVariables];
    self.scrollEnabled = NO;
    
    // one way
//    [self.panGestureRecognizer setMinimumNumberOfTouches: 2];
    
    // the another way
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.contentView addGestureRecognizer: panRecognizer];
}


-(void)move:(id)sender {
//    NSLog(@"%f,%f", self.superview.frame.origin.x, self.superview.frame.origin.y);
//    NSLog(@"%f,%f", self.contentView.frame.origin.x, self.contentView.frame.origin.y);
//    NSLog(@"%f     ", self.zoomScale);
//    NSLog(@"%f,%f   ", self.contentView.center.x, self.contentView.center.y);
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        if (!oCenterX) oCenterX = [[sender view] center].x;
        if (!oCenterY) oCenterY = [[sender view] center].y;
        
//        maxOffsetX = self.zoomScale * [[sender view] bounds].size.width / 2;
//        maxOffsetY = self.zoomScale * [[sender view] bounds].size.height / 2;
        
        NSLog(@"%f,%f     %f,%f", oCenterX, oCenterY, maxOffsetX, maxOffsetY);
    }
    
    if ( fabsf([[sender view] center].x - oCenterX) > maxOffsetX ){
        return;
    }
    if ( fabsf([[sender view] center].y - oCenterY) > maxOffsetY ){
        return;
    }
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:[sender view].superview];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    [[sender view] setCenter:translatedPoint];
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
    }
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
    }
    
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"%f   ", scale);
    
//    maxOffsetX = self.zoomScale * [[sender view] bounds].size.width / 2;
//    maxOffsetY = self.zoomScale * [[sender view] bounds].size.height / 2;
}

@end
