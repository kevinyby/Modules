#import <Foundation/Foundation.h>

@interface DictionaryHelper : NSObject

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source ;

+(NSMutableDictionary*) deepCopy: (NSDictionary*)source ;
+(void) deepCopy: (NSDictionary*)source to:(NSMutableDictionary*)destination  ;

+(NSString*) convertToJSONString: (NSDictionary*)dictionary;

#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail excepts:(NSArray*)excepts;
+(void) replace: (NSMutableDictionary*)dictionary keys:(NSArray*)keys with:(NSArray*)replacements;

#pragma mark - About Content

+(NSMutableDictionary*) subtract: (NSMutableDictionary*)dictionary withType:(Class)clazz;

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withType:(Class)clazz;
+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withObject:(id)filterObj ;

+(NSMutableDictionary*) convertNumberToString: (NSDictionary*)dictionary;

@end
