#import <Foundation/Foundation.h>

#define DATE_CLOCK_PATTERN @"HH:mm:ss"
#define DATE_PATTERN @"yyyy-MM-dd"
#define DATE_TIME_PATTERN @"yyyy-MM-dd HH:mm:ss"
#define DATE_TIME_ZONE_PATTERN @"yyyy-MM-dd HH:mm:ss Z"

@interface DateHelper : NSObject

+ (NSString *)stringFromDate:(NSDate *)date pattern:(NSString*)pattern ;

+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern ;

+ (NSString*)stringFromString:(NSString *)sourceString fromPattern:(NSString*)fromPattern toPattern:(NSString*)toPattern ;

+ (NSDateFormatter*) getLocaleDateFormater: (NSString*)pattern ;

+ (NSDate*) date: (NSDate*)date addMonth: (int)month ;

+ (NSDate*) translateDateToCurrentLocale: (NSDate*)date ;


+ (NSDate*) truncateTime: (NSDate*)date;
+ (NSDate*) truncateToday: (NSDate*)date;

@end



@interface NSDate(Operator)

@end
