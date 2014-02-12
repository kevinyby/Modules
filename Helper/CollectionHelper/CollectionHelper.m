#import "CollectionHelper.h"

@implementation CollectionHelper


#pragma mark - JSON

// collection may be Dictionary, Array, Set ...
+(NSString*) convertJSONObjectToJSONString: (id)collection
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:collection options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"CollectionHelper ConvertToJSONString Error ~~~ !!!");
        return nil;
    }
    NSString *jsonStrings = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStrings;
}



+(id) convertJSONStringToJSONObject: (NSString*)jsonString
{
    NSError* error = nil;
    NSData* jsonData = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"CollectionHelper convertJSONStringToJSONObject Error ~~~ !!!");
        return nil;
    }
    return jsonObject;
}


#pragma mark -
// temporary
+(NSMutableArray*) dictionaryToArray: (NSDictionary*)dictionary
{
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSString* key in dictionary) {
        id obj = [dictionary objectForKey: key];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray*)obj;
            [result addObjectsFromArray: array];
        } else {
            [result addObject: obj];
        }
        
    }
    return result;
}

@end
