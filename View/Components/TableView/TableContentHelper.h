#import <Foundation/Foundation.h>

@interface TableContentHelper : NSObject

+(NSString*) getStringValue: (id)value;


#pragma mark - Handler Real Content Dictionary
/**
 *
 *  @param objects objects are three dimension
 *  @param keys    the outtest dimension of objects against tho keys
 *
 *  @return realContentsDictionary
 */
+(NSMutableDictionary*) assembleToRealContentDictionary: (NSArray*)objects keys:(NSArray*)keys ;


#pragma mark - Iterate real content dictionary

+(void) iterate: (NSDictionary*)realContentDictionary handler:(BOOL (^)(id key, int row, id value))handler;




#pragma mark - Util - iterate and return the new contents dictionary

+(NSMutableDictionary*) iterateContentsDictionaryToSection: (NSDictionary*)contentDictionary handler:(void (^)(int, int, NSString*, NSArray*, NSMutableArray*))handler;

+(NSMutableDictionary*) iterateContentsDictionaryToCell: (NSDictionary*)contentDictionary handler:(void (^)(int, int, int, NSString*, id, NSMutableArray*))handler;


@end
