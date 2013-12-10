#import "LocalizeHelper.h"
#import "CategoriesLocalizer.h"

@implementation LocalizeHelper


+(NSArray*) localize: (NSArray*)array
{
    int count = array.count;
    NSMutableArray* localizes = [NSMutableArray arrayWithCapacity: count];
    for (int i = 0; i < count; i++) {
        [localizes addObject: LOCALIZE_KEY(array[i])];
    }
    return localizes;
}

@end
