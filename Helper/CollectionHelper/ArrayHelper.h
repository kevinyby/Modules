#import <Foundation/Foundation.h>

@interface ArrayHelper : NSObject

+(void) add: (NSMutableArray*)repository objs:(id)obj, ... NS_REQUIRES_NIL_TERMINATION;

+(NSMutableArray*) deepCopy: (NSArray*)source ;
+(void) deepCopy: (NSArray*)source to:(NSMutableArray*)destination  ;


+(BOOL) isTwoDimension: (NSArray*)array;


#pragma mark - Handler Contents
+(NSArray*) reRangeContents: (NSArray*)array frontContents:(NSArray*)frontContents;
+(void) subtract:(NSMutableArray*)array with:(NSArray*)subtracts;
+(NSMutableArray*) intersect: (NSArray*)array with:(NSArray*)arrayObj;

// remove the duplicate objects & maintain the orders
+(NSMutableArray*) eliminateDuplicates: (NSArray*)array;


#pragma mark -
+(CGSize) convertToSize: (NSArray*)array;
+(CGRect) convertToRect: (NSArray *)array;
+(CGPoint) convertToPoint: (NSArray *)array;
+(UIEdgeInsets) convertToEdgeInsets: (NSArray *)array;


#pragma mark -
+(NSArray*) sort:(NSArray*)array;
+(void) sortArray: (NSMutableArray*) array asc:(BOOL)isASC;

@end

