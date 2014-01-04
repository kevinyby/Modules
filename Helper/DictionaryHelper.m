#import "DictionaryHelper.h"
#import "ArrayHelper.h"

@implementation DictionaryHelper

+(void) combine: (NSMutableDictionary*)destination with:(NSDictionary*)source {
    NSEnumerator* sourceEnumerator = [source keyEnumerator];
    id key;
    while ((key = [sourceEnumerator nextObject])) {
        NSObject* sourceContains = [source objectForKey: key];
        NSObject* destinationContains = [destination objectForKey: key];
        
        if ([sourceContains isKindOfClass: [NSDictionary class]] && [destinationContains isKindOfClass: [NSDictionary class]]) {
            [self combine: (NSMutableDictionary*)destinationContains with:(NSDictionary*)sourceContains];
        } else {
            [destination setObject: sourceContains forKey: key];
        }
    }
}

// Note here , this method do not copy the deepest element object
+(NSMutableDictionary*) deepCopy: (NSDictionary*)source {
    NSMutableDictionary* destination = [NSMutableDictionary dictionary];
    [self deepCopy: source to:destination];
    return destination;
}
+(void) deepCopy: (NSDictionary*)source to:(NSMutableDictionary*)destination  {
    for (NSString* key in source) {
        id obj = [source objectForKey: key];
        
        if ([obj isKindOfClass: [NSDictionary class]]) {
            obj = [DictionaryHelper deepCopy:obj];
        } else if ([obj isKindOfClass: [NSArray class]]) {
            obj = [ArrayHelper deepCopy: obj];
        }
        [destination setObject: obj forKey:key];
    }
}


+(NSString*) convertToJSONString: (NSDictionary*)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStrings = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStrings;
}

#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary
{
    NSArray* allKeys = [dictionary allKeys];
    NSMutableArray* temp = [NSMutableArray arrayWithArray: allKeys];
    NSArray* sortedKeys = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    return sortedKeys;
}


+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail
{
    return [self tailKeys: dictionary with:tail excepts:nil];
}


+(NSMutableDictionary*) tailKeys: (NSDictionary*)dictionary with:(NSString*)tail excepts:(NSArray*)excepts
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        NSString* newKey = [excepts containsObject: key] ? key : [key stringByAppendingString:tail];
        [result setObject: value forKey:newKey];
    }
    return result;
}


+(void) replace: (NSMutableDictionary*)dictionary keys:(NSArray*)keys with:(NSArray*)replacements
{
    for (int i = 0; i < keys.count; i ++) {
        NSString* key = keys[i];
        id content = [dictionary objectForKey: key];
        if (content) [dictionary setObject: content forKey:replacements[i]];
    }
}

#pragma mark - About Content


+(NSMutableDictionary*) filterModel: (NSDictionary*)dictionary filterContent:(id)filterObj {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if (value == filterObj) continue;
        
        if ([filterObj isKindOfClass:[NSString class]]) {
            if ([filterObj isEqualToString: value]) continue;
        }
        
        [result setObject: value forKey:key];
    }
    return result;
}



+(NSMutableDictionary*)filterNumberToString: (NSDictionary*)dictionary
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = dictionary[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        [result setObject: value forKey:key];
    }
    return result;
}


@end
