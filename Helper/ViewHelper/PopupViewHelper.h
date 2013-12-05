#import <Foundation/Foundation.h>

typedef void(^PopupViewActionBlock)(UIView* popView, NSInteger index);

@interface PopupViewHelper : NSObject

+(void) popAlert: (NSString*)title message:(NSString*)message actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)buttons, ... NS_REQUIRES_NIL_TERMINATION;

+(void) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION;

+(void) popoverView:(UIView*)view inView:(UIView*)inView;
+(void) popoverView:(UIView*)view inView:(UIView*)inView inRect:(CGRect)inRect arrowDirections:(UIPopoverArrowDirection)arrowDirections;
+(void) dissmissCurrentPopover;

@end
