#import "ArrayHelper.h"

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

@end
