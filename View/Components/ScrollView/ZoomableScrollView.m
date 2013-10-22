#import "ZoomableScrollView.h"

@implementation ZoomableScrollView

@synthesize contentView;


#pragma mark - Override Methods

- (id)init
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.minimumZoomScale = 1.0f;   // ios default value
        self.maximumZoomScale = 2.0f;
        self.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        
        
        contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [super addSubview: contentView];        // Do not use self , cause i override it
    }
    return self;
}

//-(void)addSubview:(UIView *)view {
//    [contentView addSubview: view];
//}

-(void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    [contentView setFrame: frame];
}


#pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return contentView;
}

@end
