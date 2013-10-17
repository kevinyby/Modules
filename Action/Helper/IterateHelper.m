#import "IterateHelper.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_3
#define RANDOMINT(x) arc4random_uniform(x)
#else
#define RANDOMINT(x) arc4random() % x
#endif

@implementation IterateHelper

+(void) iterate: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler {
    for (int i = 0; i < array.count; i++) {
        id obj = [array objectAtIndex: i];
        if (handler(i, obj, array.count)) return;
    }
}

+(void) iterateRadom: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler {
    int radomIndex = RANDOMINT(array.count);
    for (int i = 0, m = radomIndex; i < array.count; i++, m++) {
        if (m >= array.count) m = 0;
        id obj = [array objectAtIndex: m];
        if (handler(i, obj, array.count)) return;
    }
}

+(void) shuffle: (NSMutableArray*)array {
    int count = [array count];
    for (int i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
