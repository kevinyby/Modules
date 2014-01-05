#import "PopupViewHelper.h"

#import "_View.h"
#import "_Helper.h"



/**
 *  UIAlertView
 */
@interface PopAlertView : UIAlertView <UIAlertViewDelegate>

@property (copy) PopupViewActionBlock actionBlock;

@end

@implementation PopAlertView

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PopAlertView* popupView = (PopAlertView*)alertView;
    if (popupView.actionBlock) popupView.actionBlock(popupView, buttonIndex);
}

@end




/**
 *  UIActionSheet
 */
@interface PopActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (copy) PopupViewActionBlock actionBlock;

@end

@implementation PopActionSheet

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PopActionSheet* popupView = (PopActionSheet*)actionSheet;
    if (popupView.actionBlock) popupView.actionBlock(popupView, buttonIndex);
}

@end


/**
 * Overlay View
 */
@interface OverlayView : UIControl

@property (copy) void(^didDidTapActionBlock)(OverlayView* overlayView);

@end

@implementation OverlayView

- (id)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(didDidTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) didDidTapAction
{
    if(self.didDidTapActionBlock) self.didDidTapActionBlock(self);
}

@end

/**
 *  PopupViewHelper
 */
@implementation PopupViewHelper


+(UIAlertView*) popAlert: (NSString*)title message:(NSString*)message actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION
{
    PopAlertView* popupView = [[PopAlertView alloc] init];
    popupView.actionBlock = actionBlock;
    popupView.delegate = popupView;
    popupView.message = message;
    popupView.title = title;
    
    
    if (button) [popupView addButtonWithTitle: button];
    
    // button not in list , list is for ...
    // button just indicates where the compiler needs to go in memory to find the start of args
    // take a look at http://www.numbergrinder.com/2008/12/variable-arguments-varargs-in-objective-c/
    va_list list;
    va_start(list, button);
    
    NSString* nextButton = nil;
    while((nextButton = va_arg(list, NSString*))){
        [popupView addButtonWithTitle: nextButton];
    }
    
    va_end(list);
    
    
    [popupView show];
    
    return popupView;
}


+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION
{

    NSMutableArray* buttonTitles = [NSMutableArray array];
    if (button) [buttonTitles addObject: button];
    
    va_list list ;
    va_start(list, button);
    NSString* nextButton = nil;
    while((nextButton = va_arg(list, NSString*))){
        [buttonTitles addObject: nextButton];
    }
    va_end(list);
    
    return [self popSheet:title inView:inView actionBlock:actionBlock buttonTitles:buttonTitles];
}

+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttonTitles:(NSArray*)buttonTitles
{
    PopActionSheet* popupView = [[PopActionSheet alloc] init];
    popupView.actionBlock = actionBlock;
    popupView.delegate = popupView;
    popupView.title = title;
    
    for (int i = 0; i < buttonTitles.count; i++) {
        NSString* buttonTitle = buttonTitles[i];
        [popupView addButtonWithTitle: buttonTitle];
    }
    
    if (!inView) inView = [UIApplication sharedApplication].keyWindow.subviews.firstObject;
	[popupView showInView:inView];
    
    return popupView;
}


static NSMutableArray* currentPopingViews = nil;
+(void) popView: (UIView*)view willDissmiss:(void(^)(UIView* view))block
{
    OverlayView* overlayView = [[OverlayView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    CGRect bounds = [PopupViewHelper getScreenBoundsByOrientation];
    overlayView.frame = bounds;
    
    overlayView.didDidTapActionBlock = ^void(OverlayView* view) {
        [self dissmissCurrentPopView];
    };
    [overlayView addSubview: view];
    
    UIView* rootView = [self getRootView];
    [rootView addSubview: overlayView];
    
    if (!currentPopingViews) currentPopingViews = [NSMutableArray array];
    [currentPopingViews addObject: overlayView];
    if (block) {
        [currentPopingViews addObject: block];
    } else {
        [currentPopingViews addObject: [NSNull null]];
    }
    
}

+(void) dissmissCurrentPopView
{
    UIView* overlayView = [currentPopingViews firstObject];
    if (overlayView) {
        
        [currentPopingViews removeObjectAtIndex: 0];
        id block = [currentPopingViews firstObject];
        if (block) {
            [currentPopingViews removeObjectAtIndex: 0];
            if (block != [NSNull null]) {
                void(^willDissmissBlock)(UIView* view) = block;
                willDissmissBlock([overlayView.subviews lastObject]);
            }
        }
    }
    [UIView animateWithDuration:0.2 animations:^{overlayView.alpha = 0.0;} completion:^(BOOL finished){ [overlayView removeFromSuperview]; }];
}

+(UIView*) getTopview
{
    UIViewController* rootViewController = [self getRootViewController];
    UIView* topView = nil ;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        topView = navigationController.topViewController.view;
    } else {
        topView = rootViewController.view;
    }
    return topView;
}

+(UIView*) getRootView
{
    return [[[[UIApplication sharedApplication] keyWindow] subviews] firstObject];
}

+(UIViewController*) getRootViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

+(CGRect) getScreenBoundsByOrientation
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    float screenWidth = screenSize.size.width;
    float screenHeight = screenSize.size.height;
    
    UIViewController* rootViewController = [self getRootViewController];
    UIInterfaceOrientation orientation = rootViewController.interfaceOrientation;
    CGRect rect = UIInterfaceOrientationIsPortrait(orientation) ? (CGRect){{0,0},{screenWidth,screenHeight}} : (CGRect){{0,0},{screenHeight,screenWidth}};
    return rect;
}





#define DROPDOWN_OVERLAYVIEW_TAG 2021
+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView
{
    [self dropDownView: view belowView:belowView overlayFrame:[self getTopview].bounds];
}

+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView overlayFrame:(CGRect)overlayFrame
{
    [self dissmissCurrentDropDownView];
    
    OverlayView* overlayView = [[OverlayView alloc] init];
    overlayView.backgroundColor = [UIColor clearColor];
//    [ColorHelper setBorder: overlayView];
    overlayView.didDidTapActionBlock = ^void(OverlayView* view) {
        [self dissmissCurrentDropDownView];
    };
    
    overlayView.frame = overlayFrame;
    UIView* topView = [self getTopview];
    [topView addSubview:overlayView];
    
    [view setOrigin: [belowView convertPoint: (CGPoint){0, belowView.frame.size.height} toView:overlayView]];
    
    overlayView.tag = DROPDOWN_OVERLAYVIEW_TAG;
    [overlayView addSubview: view];
}

+(void) dissmissCurrentDropDownView
{
    UIView* topView = [self getTopview];
    UIView* overlayView = [topView viewWithTag: DROPDOWN_OVERLAYVIEW_TAG];
    [overlayView removeFromSuperview];
}









//////////////////___________________________________

static UIActionSheet* actionSheet;
static UIPopoverController* popoverController = nil;        // http://stackoverflow.com/questions/8895071/uipopovercontroller-dealloc-reached-while-popover-is-still-visible

+(void) popoverView:(UIView*)view inView:(UIView*)inView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [PopupViewHelper popoverView: view inView:inView inRect:view.frame arrowDirections:UIPopoverArrowDirectionAny];
        
    } else {
        
        if (! actionSheet) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action" delegate:nil cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:nil];
            [actionSheet setActionSheetStyle: UIActionSheetStyleDefault];
        }
        [actionSheet.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [actionSheet addSubview: view];
        [actionSheet showInView: inView];
//        CGRect actionSheetRect = actionSheet.bounds; // title & one button : (CGRect){{0,0},{568,108.5}};
        
        if ([view getSizeWidth] > actionSheet.frame.size.width) [view setSizeWidth: actionSheet.frame.size.width - 16];
        [view setSizeHeight: actionSheet.frame.size.height - 12];
        
        CGPoint center = [actionSheet convertPoint: actionSheet.center fromView:actionSheet.superview];
        [view setCenterX: center.x];
    }
}


// ---- Begin ------------------------------------------------------------

// (Just for Pad)
// arrowDirections = 0 for no direction , the popoverController.contentViewController's would be same as [FromRect]'s center
+(void) popoverView:(UIView*)view inView:(UIView*)inView inRect:(CGRect)inRect arrowDirections:(UIPopoverArrowDirection)arrowDirections
{
    CGRect rect = inRect ; //CGRectMake(100, 200, 300, 200);
//    UIView* rectView = [[UIView alloc] initWithFrame: rect];      // To see how the popoverController fit itself's position
//    [ColorHelper setBorder: rectView];
//    [inView addSubview: rectView];
    
    if (! popoverController) {
        UIViewController *viewController = [[UIViewController alloc] init];
        popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//#pragma GCC diagnostic push
//#pragma GCC diagnostic ignored "-fdiagnostics-show-option"
//#pragma GCC diagnostic ignored "-Wno-pointer-sign"
        popoverController.delegate = (id<UIPopoverControllerDelegate>)[PopupViewHelper class];      // ok , i failed
//#pragma GCC diagnostic pop
    }
    UIViewController *viewController = popoverController.contentViewController;
//    [viewController.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [viewController.view addSubview: view];
    viewController.view = view;
    viewController.preferredContentSize = view.bounds.size;
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow.subviews.firstObject;
    }
    [popoverController presentPopoverFromRect: rect inView:inView permittedArrowDirections:arrowDirections animated:YES];
}

+(void) dissmissCurrentPopover
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [popoverController dismissPopoverAnimated: YES] ;
    } else {
        [actionSheet dismissWithClickedButtonIndex: 0 animated:YES];
    }
}

#pragma mark - UIPopoverControllerDelegate Methods
+(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverControllerObj
{
    //    popoverController = nil;
}

// ---- End ------------------------------------------------------------





@end
