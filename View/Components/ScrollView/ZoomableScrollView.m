#import "ZoomableScrollView.h"

@implementation ZoomableScrollView

@synthesize contentView;


#pragma mark - Override Methods

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeVariable];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVariable];
    }
    return self;
}

-(void) initializeVariable {
    self.delegate = self;
    self.scrollEnabled = YES;
    self.minimumZoomScale = 1.0f;   // ios default value
    self.maximumZoomScale = 2.0f;
    self.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    
    
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    [super addSubview: contentView];
    
}

-(void) addSubview:(UIView *)view {
    [contentView addSubview: view];
}

-(NSArray*) subViews {
    return contentView.subviews;
}

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
