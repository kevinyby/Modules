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


+ (NSString*)stringFromString:(NSString *)sourceString fromPattern:(NSString*)fromPattern toPattern:(NSString*)toPattern {
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
    pattern = pattern == nil ? DATE_TIME_ZONE_PATTERN : pattern;
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

+ (NSDate*) date: (NSDate*)date addDay: (int)day {
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];
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


// e.g. 2010-10-30 10:14:13 -> 2010-10-30 00:00:00
+ (NSDate*) truncateTime: (NSDate*)date
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* truncateDate = [calendar dateFromComponents:components];
//           truncateDate = [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
    return truncateDate;
}

// e.g. 2010-10-30 10:14:13 -> 2013-11-20 10:14:13  (2013-11-20 is today)
+ (NSDate*) truncateToday: (NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger preservedTimeComponents = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate* truncateDateTime = [calendar dateFromComponents:[calendar components:preservedTimeComponents fromDate:date]];
    
    NSDate *nowDate = [NSDate date];
    NSCalendarUnit preservedDayComponents = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDate* truncateDateDay = [calendar dateFromComponents:[calendar components:preservedDayComponents fromDate:nowDate]];
    
    NSDate *newDate = [calendar dateByAddingComponents:[calendar components:preservedTimeComponents fromDate:truncateDateTime] toDate:truncateDateDay options:0];
    return newDate;
}


@end





@implementation NSDate(Operator)

/**
 *  compare with time
 */

-(BOOL) GT:(NSDate*)date
{
    return [self compare: date] == NSOrderedDescending;
}

-(BOOL) LT:(NSDate*)date
{
    return [self compare: date] == NSOrderedAscending;
}

-(BOOL) EQ:(NSDate*)date
{
    return [self compare: date] == NSOrderedSame;
}

-(BOOL) GTEQ:(NSDate*)date
{
    return [self GT: date] || [self EQ:date];
}

-(BOOL) LTEQ:(NSDate*)date
{
    return [self LT: date] || [self EQ:date];
}


/**
 *  compare without time
 */
-(BOOL) GTD:(NSDate*)date
{
    return [[DateHelper truncateTime:self] compare: [DateHelper truncateTime:date]] == NSOrderedDescending;
}

-(BOOL) LTD:(NSDate*)date
{
    return [[DateHelper truncateTime:self] compare: [DateHelper truncateTime:date]] == NSOrderedAscending;
}

-(BOOL) EQD:(NSDate*)date
{
    return [[DateHelper truncateTime:self] compare: [DateHelper truncateTime:date]] == NSOrderedSame;
}

-(BOOL) GTEQD:(NSDate*)date
{
    return [self GTD: date] || [self EQD:date];
}

-(BOOL) LTEQD:(NSDate*)date
{
    return [self LTD: date] || [self EQD:date];
}


@end




