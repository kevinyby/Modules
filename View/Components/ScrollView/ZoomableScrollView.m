#import "ZoomableScrollView.h"

@implementation ZoomableScrollView

@synthesize contentView;

#pragma mark - Override Methods

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVariables];
    }
    return self;
}

-(void) initializeVariables {
    self.delegate = self;
    self.scrollEnabled = YES;           // if YES, will affect the Button's click effect, and UITableView , so , in subclass we have to use UIPanGestureRecognizer to drag
    self.minimumZoomScale = 1.0f;       // ios default value
    self.maximumZoomScale = 2.0f;
    self.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    [super addSubview: contentView];
    
}

-(NSArray*) contentViewSubviews
{
    return contentView.subviews;
}

-(void) addSubviewToContentView: (UIView*)view
{
    [contentView addSubview: view];
}

// for easy debug , comment it will be better !!!
//-(void) addSubview:(UIView *)view {
//    [contentView addSubview: view];
//}

// Will cause subvei auto layout constraints no effect !!!
//-(NSArray *)subviews
//{
//    return contentView.subviews;
//}

-(void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    [contentView setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
}


#pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return contentView;
}

@end
