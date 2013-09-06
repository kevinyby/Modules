#import "RotatableViewController.h"

@interface RotatableViewController ()

@end

@implementation RotatableViewController

#pragma mark
-(void) renderByOrientation: (UIInterfaceOrientation)toInterfaceOrientation {}

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

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"[%@] instance willRotateToInterfaceOrientation", [self class]);
    [self renderByOrientation:(UIInterfaceOrientation)toInterfaceOrientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
