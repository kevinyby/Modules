#import <Foundation/Foundation.h>

@interface ViewHelper : NSObject

+(void) appendShadowView: (UIView*)view config:(NSDictionary*)config ;

+(void) sortedSubviewsByXCoordinate: (UIView*)view;
@end
