#import <UIKit/UIKit.h>

@interface NormalButton : UIButton

@property (copy) void (^didClikcButtonAction)(id sender) ;

@end
