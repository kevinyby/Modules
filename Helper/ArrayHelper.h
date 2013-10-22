#import <Foundation/Foundation.h>

@interface ArrayHelper : NSObject

+(void) add: (NSMutableArray*)repository objs:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;

@end
