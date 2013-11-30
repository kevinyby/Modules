#import "PopupViewHelper.h"
#import "CategoriesLocalizer.h"



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
    
	[popupView showInView:inView];
}


@end
