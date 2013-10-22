#import "DictionaryHelper.h"

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

@end
