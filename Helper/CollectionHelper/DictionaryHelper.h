#import <Foundation/Foundation.h>

@interface DictionaryHelper : NSObject

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source ;

+(NSMutableDictionary*) deepCopy: (NSDictionary*)source ;
+(void) deepCopy: (NSDictionary*)source to:(NSMutableDictionary*)destination  ;

#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail excepts:(NSArray*)excepts;
+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary keys:(NSArray*)keys with:(NSString*)tail;
+(void) replaceKeys: (NSMutableDictionary*)dictionary keys:(NSArray*)keys withKeys:(NSArray*)replacements;

#pragma mark - About Values

+(NSMutableDictionary*) subtract: (NSMutableDictionary*)dictionary withType:(Class)clazz;

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withType:(Class)clazz;
+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withObject:(id)filterObj ;
+(NSMutableDictionary*) filter: (NSDictionary*)dictionary filter:(BOOL(^)(id value))filter ;

+(NSMutableDictionary*) convertNumberToString: (NSDictionary*)dictionary;


#pragma mark - About Keys and Values
+(NSMutableDictionary*) convertToOneDimensionDictionary: (NSDictionary*)dictionary;

+(NSMutableDictionary*) convert: (NSArray*)values keys:(NSArray*)keys;

#pragma mark - Get the depth
+(NSInteger) getTheDepth: (NSDictionary*)dictionary;


@end
