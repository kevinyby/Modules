#import "PopupViewHelper.h"
#import "CategoriesLocalizer.h"

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
 *  PopupViewHelper
 */
@implementation PopupViewHelper


+(void) popAlert: (NSString*)title message:(NSString*)message actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION
{
    PopAlertView* popupView = [[PopAlertView alloc] init];
    popupView.actionBlock = actionBlock;
    popupView.delegate = popupView;
    popupView.message = message;
    popupView.title = title;
    
    
    if (button) [popupView addButtonWithTitle: LOCALIZE_KEY(button)];
    
    // button not in list , list is for ...
    // button just indicates where the compiler needs to go in memory to find the start of args
    // take a look at http://www.numbergrinder.com/2008/12/variable-arguments-varargs-in-objective-c/
    va_list list;
    va_start(list, button);
    
    NSString* nextButton = nil;
    while((nextButton = va_arg(list, NSString*))){
        [popupView addButtonWithTitle: LOCALIZE_KEY(nextButton)];
    }
    
    va_end(list);
    
    
    [popupView show];
}


+(void) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION
{
    PopActionSheet* popupView = [[PopActionSheet alloc] init];
    popupView.actionBlock = actionBlock;
    popupView.delegate = popupView;
    popupView.title = title;
    
    if (button) [popupView addButtonWithTitle: LOCALIZE_KEY(button)];
    
    va_list list ;
    va_start(list, button);
    
    NSString* nextButton = nil;
    while((nextButton = va_arg(list, NSString*))){
        [popupView addButtonWithTitle: LOCALIZE_KEY(nextButton)];
    }
    
    va_end(list);
    
    if (!inView) inView = [UIApplication sharedApplication].keyWindow.subviews.firstObject;
	[popupView showInView:inView];
}





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


// ---- Begin (Just for Pad) ------------------------------------------------------------


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
