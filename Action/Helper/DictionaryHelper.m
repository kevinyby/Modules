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

@end
