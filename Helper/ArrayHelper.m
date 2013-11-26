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


+(void) deepCopy: (NSArray*)source to:(NSMutableArray*)destination  {
    for (int i = 0; i < source.count; i++) {
        id obj = [source objectAtIndex: i];
        
        if ([obj isKindOfClass: [NSArray class]]) {
            NSMutableArray* subDestination = [NSMutableArray array];
            [ArrayHelper deepCopy:obj to:subDestination];
            obj = subDestination;
        } else if ([obj isKindOfClass: [NSDictionary class]]) {
            NSMutableDictionary* subDestination = [NSMutableDictionary dictionary];
            [DictionaryHelper deepCopy:obj to:subDestination];
            obj = subDestination;
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





@implementation NSArray (SafeGetter)

-(id)objectSafeAtIndex:(NSUInteger)index
{
    return ((int)self.count - 1) < (int)index ? nil : [self objectAtIndex: index];
}

@end
