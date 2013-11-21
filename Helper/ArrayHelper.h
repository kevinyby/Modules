#import <Foundation/Foundation.h>

@interface ArrayHelper : NSObject

+(void) add: (NSMutableArray*)repository objs:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;
+(void) deepCopy: (NSArray*)source to:(NSMutableArray*)destination  ;


+(BOOL) isTwoDimension: (NSArray*)array;

@end





@interface NSArray (SafeGetter)

/** @return if index >= array.count , will return nil **/
-(id)objectSafeAtIndex:(NSUInteger)index;

@end
