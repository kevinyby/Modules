#import <Foundation/Foundation.h>

#define degreeToRadian(x) (x * M_PI / 180.0)

@interface LayerHelper : NSObject

+(void) setAnchorPoint:(CGPoint)anchorpoint forLayer:(CALayer*)layer;

@end
