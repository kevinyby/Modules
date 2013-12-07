#import <UIKit/UIKit.h>

@interface ZoomableScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong) UIView* contentView;

-(NSArray*) subViews ;

@end
