#import "LocalizeHelper.h"
#import "CategoriesLocalizer.h"

@implementation LocalizeHelper


+(NSArray*) localize: (NSArray*)array
{
    NSInteger count = array.count;
    NSMutableArray* localizes = [NSMutableArray arrayWithCapacity: count];
    for (int i = 0; i < count; i++) {
        NSString* key = array[i];
        NSString* localizeValue = LOCALIZE_KEY(key);
        [localizes addObject: localizeValue];
    }
    return localizes;
}

@end
