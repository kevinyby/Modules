#import "InteractHelper.h"

@implementation InteractHelper

/** Check if double click  */
+(BOOL) isDoubleClick: (NSTimeInterval)interval {
    static NSDate* date = nil;
    static Boolean doubleClick = NO;
    NSDate* now = [NSDate date];
    if (date) doubleClick = [now timeIntervalSinceDate: date] < interval;
    date = now;
    return doubleClick;
}

@end
