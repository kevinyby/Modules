#import "RotatableViewController.h"

@interface RotatableViewController ()

@end

@implementation RotatableViewController

#pragma mark - Override UIViewController Methods
// for ios5.0 , 6.0 deprecated
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait ;
}

// for ios6.0 supported
-(BOOL) shouldAutorotate {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self renderByOrientation: self.interfaceOrientation];
}


#pragma mark - subclass shold overwrite methods

-(void) renderByOrientation: (UIInterfaceOrientation)interfaceOrientation {}

@end
