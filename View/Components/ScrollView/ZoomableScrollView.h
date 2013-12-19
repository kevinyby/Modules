#import <UIKit/UIKit.h>

@interface ZoomableScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong) UIView* contentView;

-(NSArray*) contentViewSubviews;
-(void) addSubviewToContentView: (UIView*)view;


#pragma mark - Subclass Override Methods
-(void) initializeVariables;

@end
