typedef void(^PopupViewActionBlock)(UIView* popView, NSInteger index);

@interface PopupViewHelper : NSObject

+(UIAlertView*) popAlert: (NSString*)title message:(NSString*)message style:(UIAlertViewStyle)style actionBlock:(PopupViewActionBlock)actionBlock dismissBlock:(PopupViewActionBlock)dismissBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION;
+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttonTitles:(NSArray*)buttonTitles;

+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION;

+(void) popView: (UIView*)view willDissmiss:(void(^)(UIView* view))block;
+(void) dissmissCurrentPopView;

+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView;
+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView overlayFrame:(CGRect)overlayFrame;
+(void) dissmissCurrentDropDownView;


// ------------------
+(void) popoverView:(UIView*)view inView:(UIView*)inView;
+(void) popView: (UIView*)view willDissmiss:(void(^)(UIView* view))block inRootView:(BOOL)inRootView;
+(void) popoverView:(UIView*)view inView:(UIView*)inView inRect:(CGRect)inRect arrowDirections:(UIPopoverArrowDirection)arrowDirections;
+(void) dissmissCurrentPopover;

@end
