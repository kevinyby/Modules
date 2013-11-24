#import "RotatableViewController.h"

@interface RotatableViewController ()

@end

@implementation RotatableViewController

#pragma mark - Override UIViewController Methods


//**************Rotate Needed Begin

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

//**************Rotate Needed End



- (void)viewWillAppear:(BOOL)animated {
    [self renderByOrientation: self.interfaceOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self renderByOrientation: toInterfaceOrientation];
}


#pragma mark - subclass shold overwrite methods

-(void) renderByOrientation: (UIInterfaceOrientation)interfaceOrientation {}

@end
