#import <UIKit/UIKit.h>

typedef void(^NormalButtonDidClickBlock)(id sender) ;

@interface NormalButton : UIButton

@property (copy) NormalButtonDidClickBlock didClikcButtonAction;

@end
