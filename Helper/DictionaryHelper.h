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

#pragma mark - About Content

+(NSMutableDictionary*) filterModel: (NSDictionary*)dictionary filterContent:(id)filterObj ;

@end
