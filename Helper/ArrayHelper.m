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

@end
