#import <Foundation/Foundation.h>

@interface FrameManager : NSObject

+(void) setSubViewsFrames: (UIView*)view config:(NSDictionary*)config;

+(CGRect) convertToRect: (NSArray *)rectArray;


@end
