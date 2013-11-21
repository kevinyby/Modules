#import "DictionaryHelper.h"
#import "ArrayHelper.h"

@implementation DictionaryHelper

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source {
    NSEnumerator* enumerator = [source keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        NSObject* contains = [source objectForKey: key];
        if ([contains isKindOfClass: [NSDictionary class]] && [destination objectForKey: key]) {
            [self combine: [destination objectForKey: key] with:(NSDictionary*)contains];
        } else {
            [destination setObject: contains forKey: key];
        }
    }
}

+(void) deepCopy: (NSDictionary*)source to:(NSMutableDictionary*)destination  {
    for (NSString* key in source) {
        id obj = [source objectForKey: key];
        
        if ([obj isKindOfClass: [NSDictionary class]]) {
            NSMutableDictionary* subDestination = [NSMutableDictionary dictionary];
            [DictionaryHelper deepCopy:obj to:subDestination];
            obj = subDestination;
        } else if ([obj isKindOfClass: [NSArray class]]) {
            NSMutableArray* subDestination = [NSMutableArray array];
            [ArrayHelper deepCopy: obj to:subDestination];
            obj = subDestination;
        }
        [destination setObject: obj forKey:key];
        
    }
}


+(NSArray*) getSortedKeys: (NSDictionary*)dictionary
{
    NSArray* allKeys = [dictionary allKeys];
    NSMutableArray* temp = [NSMutableArray arrayWithArray: allKeys];
    NSArray* sortedKeys = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    return sortedKeys;
}


+(NSString*) convertToJSONString: (NSDictionary*)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStrings = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStrings;
}


@end
