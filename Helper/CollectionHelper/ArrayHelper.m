#import "ArrayHelper.h"
#import "DictionaryHelper.h"

#import "NSArray+Additions.h"

@implementation ArrayHelper

// [ArrayHelper add: array objs:@"1", nil] . Do not forget the "nil"
+(void) add: (NSMutableArray*)repository objs:(id)obj, ... {
    id arg = nil;
    va_list params;
    if (obj) {
        [repository addObject: obj];
        va_start(params, obj);
        while ((arg = va_arg(params, id))) {
            if (arg) [repository addObject: arg];
        }
        va_end(params);
    }
}

// Note here , this method do not copy the deepest element object
+(NSMutableArray*) deepCopy: (NSArray*)source {
    NSMutableArray* destination = [NSMutableArray array];
    [self deepCopy: source to:destination];
    return destination;
}
+(void) deepCopy: (NSArray*)source to:(NSMutableArray*)destination  {
    for (int i = 0; i < source.count; i++) {
        id obj = [source objectAtIndex: i];
        
        if ([obj isKindOfClass: [NSArray class]]) {
            obj = [ArrayHelper deepCopy:obj];
        } else if ([obj isKindOfClass: [NSDictionary class]]) {
            obj = [DictionaryHelper deepCopy:obj];
        }
        [destination addObject: obj];
        
    }
}


+(BOOL) isTwoDimension: (NSArray*)array
{
    return [[array firstObject] isKindOfClass: [NSArray class]];
}


#pragma mark - Handler Contents

// array: ["4","5","6","1","2"], frontContents:["1","2", "3", "100"]
// return ["1","2", "4","5","6"], just put the frontContents to front
+(NSArray*) reRangeContents: (NSArray*)array frontContents:(NSArray*)frontContents
{
    NSMutableArray* newContents = [ArrayHelper deepCopy: array];
    NSArray* intersections = [ArrayHelper intersect: array with:frontContents];
    [ArrayHelper subtract: newContents with: intersections];             // remove the front keys in array
    [newContents insertObjects: intersections atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSRange){0, intersections.count}]];  // then insert the front keys in the front
    return newContents;
}

+(void) subtract:(NSMutableArray*)array with:(NSArray*)subtracts
{
    for (id element in subtracts) {
        if ([array containsObject: element]){
            [array removeObject: element];
        }
    }
}

+(NSMutableArray*) intersect: (NSArray*)array with:(NSArray*)arrayObj
{
    NSMutableArray* result = [NSMutableArray array];
    for (NSUInteger i = 0; i < arrayObj.count; i++) {
        id obj = arrayObj[i];
        if ([array containsObject: obj]) {
            [result addObject: obj];
        }
    }
    return result;
}


// remove the duplicate objects & maintain the orders
+(NSMutableArray*) eliminateDuplicates: (NSArray*)array
{
    NSMutableArray* result = [NSMutableArray array];
    for (NSUInteger i = 0; i < array.count; i++) {
        id obj = array[i];
        if (![result containsObject: obj])  [result addObject: obj];
    }
    return  result;
}


#pragma mark - 

+(CGPoint) convertToPoint: (NSArray *)array
{
    return CGPointMake([[array safeObjectAtIndex: 0] floatValue],
                      [[array safeObjectAtIndex: 1] floatValue]);
}
+(CGSize) convertToSize: (NSArray*)array
{
    return CGSizeMake([[array safeObjectAtIndex: 0] floatValue],
                       [[array safeObjectAtIndex: 1] floatValue]);
}
/** @prama rectArray @[@(0), @(0) @(200), @(50)] */
+(CGRect) convertToRect: (NSArray *)array
{
    return CGRectMake([[array safeObjectAtIndex: 0] floatValue],
                      [[array safeObjectAtIndex: 1] floatValue],
                      [[array safeObjectAtIndex: 2] floatValue],
                      [[array safeObjectAtIndex: 3] floatValue]);
}
+(UIEdgeInsets) convertToEdgeInsets: (NSArray *)array
{
    return UIEdgeInsetsMake([[array safeObjectAtIndex: 0] floatValue],
                            [[array safeObjectAtIndex: 1] floatValue],
                            [[array safeObjectAtIndex: 2] floatValue],
                            [[array safeObjectAtIndex: 3] floatValue]);
}



#pragma mark - 

// array with string
+(NSArray*) sort:(NSArray*)array
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray: array];
    NSArray* result = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare: obj2];
    }];
    return result;
}

// array with [[1,0], [5,4]]
+(void) sortArray: (NSMutableArray*)array asc:(BOOL)isASC
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* array1 = (NSArray*)obj1;
        NSArray* array2 = (NSArray*)obj2;
        NSNumber* outerIndex1 = [array1 firstObject];
        NSNumber* outerIndex2 = [array2 firstObject];
        NSNumber* innerIndex1 = [array1 lastObject];
        NSNumber* innerIndex2 = [array2 lastObject];
        NSComparisonResult result1 = isASC ? [innerIndex1 compare: innerIndex2] : [innerIndex2 compare: innerIndex1] ;
        NSComparisonResult result2 = isASC ? [outerIndex1 compare: outerIndex2] : [outerIndex2 compare: outerIndex1] ;
        return ([outerIndex1 compare: outerIndex2] == NSOrderedSame) ? result1 : result2;
    }];
}

@end


