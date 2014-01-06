#import <Foundation/Foundation.h>

@interface ArrayHelper : NSObject

+(void) add: (NSMutableArray*)repository objs:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;

+(NSMutableArray*) deepCopy: (NSArray*)source ;
+(void) deepCopy: (NSArray*)source to:(NSMutableArray*)destination  ;


+(BOOL) isTwoDimension: (NSArray*)array;

+(NSArray*) sort:(NSArray*)array;

#pragma mark - Handler Contents
+(NSArray*) rerangeContents: (NSArray*)array frontContents:(NSArray*)frontContents;
+(void) subtract:(NSMutableArray*)array with:(NSArray*)subtracts;

#pragma mark - 
+(CGPoint) convertToPoint: (NSArray *)array;

+(CGRect) convertToRect: (NSArray *)array;

+(UIEdgeInsets) convertToEdgeInsets: (NSArray *)array;

@end

