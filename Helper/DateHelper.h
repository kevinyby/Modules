#import <Foundation/Foundation.h>

#define DATE_FORMAT @"yyyy-MM-dd"
#define DATE_TIME_FORMAT @"yyyy-MM-dd HH:mm:ss"
#define DATA_TIME_ZONE_FORMAT @"yyyy-MM-dd HH:mm:ss Z"

@interface DateHelper : NSObject

+ (NSDateFormatter*) getLocaleDateFormater: (NSString*)pattern ;

+ (NSDate*) date: (NSDate*)date addMonth: (int)month ;

+ (NSDate*) translateDateToCurrentLocale: (NSDate*)date ;

@end
