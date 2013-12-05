#import "ArrayHelper.h"
#import "DictionaryHelper.h"

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
    id obj = [array lastObject];
    return [obj isKindOfClass: [NSArray class]];
}


+(NSArray*) sort:(NSArray*)array
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray: array];
    NSArray* result = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare: obj2];
    }];
    return result;
}


@end


