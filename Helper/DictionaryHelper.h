#import <Foundation/Foundation.h>

@interface DictionaryHelper : NSObject

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source ;
+(void) deepCopy: (NSDictionary*)source to:(NSMutableDictionary*)destination  ;

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary;
+(NSString*) convertToJSONString: (NSDictionary*)dictionary;

@end
