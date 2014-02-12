#import <Foundation/Foundation.h>

@interface DictionaryHelper : NSObject

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source ;

+(NSMutableDictionary*) deepCopy: (NSDictionary*)source ;
+(void) deepCopy: (NSDictionary*)source to:(NSMutableDictionary*)destination  ;

#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail excepts:(NSArray*)excepts;
+(void) replace: (NSMutableDictionary*)dictionary keys:(NSArray*)keys with:(NSArray*)replacements;

#pragma mark - About Content

+(NSMutableDictionary*) subtract: (NSMutableDictionary*)dictionary withType:(Class)clazz;

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withType:(Class)clazz;
+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withObject:(id)filterObj ;
+(NSMutableDictionary*) filter: (NSDictionary*)dictionary filter:(BOOL(^)(id value))filter ;

+(NSMutableDictionary*) convertNumberToString: (NSDictionary*)dictionary;


#pragma mark - Temporary
+(NSMutableDictionary*) convertToOneDimensionDictionary: (NSDictionary*)dictionary;

@end
