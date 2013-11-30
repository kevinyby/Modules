#import <Foundation/Foundation.h>

typedef void(^PopupViewActionBlock)(UIView* view, NSInteger index);

@interface PopupViewHelper : NSObject

+(void) popAlert: (NSString*)title message:(NSString*)message actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)buttons, ... NS_REQUIRES_NIL_TERMINATION;

+(void) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION;

@end
