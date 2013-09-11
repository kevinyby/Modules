#import <UIKit/UIKit.h>

@interface RotatableViewController : UIViewController

#pragma mark - subclass shold overwrite methods

-(void) renderByOrientation: (UIInterfaceOrientation)interfaceOrientation ;

@end
