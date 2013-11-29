@interface IterateHelper : NSObject

+(void) iterate: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler ;
+(void) iterateRadom: (NSArray*)array handler:(BOOL (^)(int index, id obj, int count))handler ;
+(void) shuffle: (NSMutableArray*)array ;


+(void) iterateDictionary:(NSDictionary*)dictionary handler:(BOOL (^)(id key, id value))handler;

@end
