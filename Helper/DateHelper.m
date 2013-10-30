#import "DateHelper.h"

@implementation DateHelper

+ (NSDateFormatter*) getLocaleDateFormater: (NSString*)pattern {
    //    NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    //    NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [df setTimeZone: timeZone];
    NSLocale* locale = [NSLocale currentLocale];
    [df setLocale: locale];
    pattern = pattern == nil ? DATA_TIME_ZONE_FORMAT : pattern;
    [df setDateFormat:pattern];
    return df;
}

+ (NSDate*) date: (NSDate*)date addMonth: (int)month {
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth: month];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*) translateDateToCurrentLocale: (NSDate*)date {           //TODO: Have something wrong . Failed
    NSDateFormatter *dateFormatter = [self getLocaleDateFormater: nil];
    NSString* dateString = [dateFormatter stringFromDate: date];
    NSLog(@"Local date string %@", dateString);
    NSDate* newDate = [dateFormatter dateFromString: dateString];
    return newDate;
}



@end
