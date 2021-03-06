#import <Foundation/Foundation.h>

#define DATE_CLOCK_PATTERN @"HH:mm:ss"
#define DATE_PATTERN @"yyyy-MM-dd"
#define DATE_TIME_PATTERN @"yyyy-MM-dd HH:mm:ss"
#define DATE_TIME_ZONE_PATTERN @"yyyy-MM-dd HH:mm:ss Z"

@interface DateHelper : NSObject

+ (NSString *)stringFromDate:(NSDate *)date pattern:(NSString*)pattern ;

+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern ;

+ (NSString*)stringFromString:(NSString *)sourceString fromPattern:(NSString*)fromPattern toPattern:(NSString*)toPattern ;

+ (void) setDefaultDatePattern: (NSString*)pattern ;
+ (NSDateFormatter*) getDefaultDateFormater ;
+ (NSDateFormatter*) getLocaleDateFormater: (NSString*)pattern ;

+ (NSDate*) date: (NSDate*)date addDay: (int)day ;
+ (NSDate*) date: (NSDate*)date addMonth: (int)month ;

+ (NSDate*) translateDateToCurrentLocale: (NSDate*)date ;


+ (NSDate*) truncateTime: (NSDate*)date;
+ (NSDate*) truncateToday: (NSDate*)date;

@end



@interface NSDate(Operator)

// GT for Greate Than


/**
 *  compare with time
 */
-(BOOL) GT:(NSDate*)date;
-(BOOL) LT:(NSDate*)date;
-(BOOL) EQ:(NSDate*)date;
-(BOOL) GTEQ:(NSDate*)date;
-(BOOL) LTEQ:(NSDate*)date;

/**
 *  compare without time
 */
-(BOOL) GTD:(NSDate*)date;
-(BOOL) LTD:(NSDate*)date;
-(BOOL) EQD:(NSDate*)date;
-(BOOL) GTEQD:(NSDate*)date;
-(BOOL) LTEQD:(NSDate*)date;


@end
