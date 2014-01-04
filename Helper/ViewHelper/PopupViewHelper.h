#import <Foundation/Foundation.h>

typedef void(^PopupViewActionBlock)(UIView* popView, NSInteger index);

@interface PopupViewHelper : NSObject

+(UIAlertView*) popAlert: (NSString*)title message:(NSString*)message actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)buttons, ... NS_REQUIRES_NIL_TERMINATION;
+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttonTitles:(NSArray*)buttonTitles;

+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION;

+(void) popView: (UIView*)view willDissmiss:(void(^)(UIView* view))block;
+(void) dissmissCurrentPopView;

+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView;
+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView overlayFrame:(CGRect)overlayFrame;
+(void) dissmissCurrentDropDownView;




+(UIView*) getTopview;
+(UIView*) getRootView;
+(CGRect) getScreenBoundsByOrientation;
+(UIViewController*) getRootViewController;


// ------------------
+(void) popoverView:(UIView*)view inView:(UIView*)inView;
+(void) popoverView:(UIView*)view inView:(UIView*)inView inRect:(CGRect)inRect arrowDirections:(UIPopoverArrowDirection)arrowDirections;
+(void) dissmissCurrentPopover;

@end
