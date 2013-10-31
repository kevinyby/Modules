#import "DateHelper.h"

@implementation DateHelper


#pragma mark - String To Date / Date To String / Format Transform

+ (NSString *)stringFromDate:(NSDate *)date pattern:(NSString*)pattern {
    NSDateFormatter* df = [self getLocaleDateFormater: pattern];
    NSString *string = [df stringFromDate:date];
    return string;
}


+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern {
    NSDateFormatter* df = [self getLocaleDateFormater: pattern];
    NSDate *date= [df dateFromString:string];
    return date;
    
}


+(NSString*)stringFromString:(NSString *)sourceString fromPattern:(NSString*)fromPattern toPattern:(NSString*)toPattern {
    NSDateFormatter* df = [self getLocaleDateFormater: fromPattern];
    NSDate *date= [df dateFromString:sourceString];
    [df setDateFormat: toPattern];
    NSString *string = [df stringFromDate:date];
    return string;
}


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
