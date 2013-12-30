#import "ZoomablePanScrollView.h"

@implementation ZoomablePanScrollView
{
    float firstX;
    float firstY;
    
    float originCenterX;
    float originCenterY;
}

-(void) initializeVariables__
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
    NSLog(@"%f,%f   ", [sender view].center.x, [sender view].center.y);
    NSLog(@"%@", NSStringFromCGRect([sender view].frame));
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
    }
    
//    if ( fabsf([[sender view] center].x + [[sender view] frame].size.width / 2 ) >= [[sender view] frame].size.width ){
//        return;
//    }
//    if ( fabsf([[sender view] center].y + [[sender view] frame].size.height / 2 ) >= [[sender view] frame].size.height ){
//        return;
//    }
    
    if ([[sender view] center].x < 0 ){
        
        [sender view].center = CGPointMake(0, [sender view].center.y);
        return;
    }
    
    if ([[sender view] center].x > [[sender view] frame].size.width ){
        
        [sender view].center = CGPointMake([[sender view] frame].size.width, [sender view].center.y);
        return;
    }
    
    if ([[sender view] center].y < 0 ) {
        
        [sender view].center = CGPointMake([sender view].center.x, 0);
        return;
    }
    
    if ([[sender view] center].y > [[sender view] frame].size.height ){
        
        [sender view].center = CGPointMake([sender view].center.x, [[sender view] frame].size.height);
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


// scrollView.frame :   not change
// scrollView.bounds :  size not change , but , origin change

// view.frame :         size change (origin * scale) , but , origin not change
// view.bounds :        not change

// view.center :        change (origin * scale)

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
//    NSLog(@"%@", [NSString stringWithFormat:@"%p" ,view]);
    NSLog(@"%f,%f", view.center.x, view.center.y);
    
    NSLog(@"%@", NSStringFromCGRect(scrollView.frame));
    NSLog(@"%@", NSStringFromCGRect(scrollView.bounds));
    
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    NSLog(@"%@", NSStringFromCGRect(view.bounds));
    
    if (!originCenterX) originCenterX = [view center].x;
    if (!originCenterY) originCenterY = [view center].y;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
//    NSLog(@"%@", [NSString stringWithFormat:@"%p" ,view]);
    NSLog(@"***************** %f *****************", scale);
    NSLog(@"%f,%f", view.center.x, view.center.y);
    
    NSLog(@"%@", NSStringFromCGRect(scrollView.frame));
    NSLog(@"%@", NSStringFromCGRect(scrollView.bounds));
    
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    NSLog(@"%@", NSStringFromCGRect(view.bounds));
    
    // view.center.x = view's origin center.x * scale, view.center.y = view's origin center.y * scale
}

@end
