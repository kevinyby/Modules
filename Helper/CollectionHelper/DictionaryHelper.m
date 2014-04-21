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

#pragma mark = About Key

+(NSArray*) getSortedKeys: (NSDictionary*)dictionary
{
    if (! dictionary) return nil;
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
    for (NSString* key in dictionary) {
        id value = [dictionary objectForKey: key];
        NSString* newKey = [excepts containsObject: key] ? key : [key stringByAppendingString:tail];
        [result setObject: value forKey: newKey];
    }
    return result;
}

+(void) replaceKeys: (NSMutableDictionary*)dictionary keys:(NSArray*)keys withKeys:(NSArray*)replacements
{
    if (! [dictionary isKindOfClass:[dictionary class]]) return;
    for (int i = 0; i < keys.count; i ++) {
        NSString* key = keys[i];
        id content = [dictionary objectForKey: key];
        if (content) [dictionary setObject: content forKey:replacements[i]];
    }
}

#pragma mark - About Values

// return the subtract contents
+(NSMutableDictionary*) subtract: (NSMutableDictionary*)dictionary withType:(Class)clazz
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSArray* keys = [dictionary allKeys];
    for (NSString* key in keys) {
        id value = [dictionary objectForKey: key];
        
        if ([value isKindOfClass:clazz]) {
            [result setObject: value forKey:key];
            [dictionary removeObjectForKey: key];
        }
    }
    return result;
}

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withType:(Class)clazz {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if ([value isKindOfClass:clazz]) continue;
        
        [result setObject: value forKey:key];
    }
    return result;
}


+(NSMutableDictionary*) filter: (NSDictionary*)dictionary withObject:(id)filterObj {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if (value == filterObj) continue;
        
        // http://stackoverflow.com/questions/2293859/checking-for-equality-in-objective-c
        
        if ([value isEqual: filterObj]) continue;
        
        [result setObject: value forKey:key];
    }
    return result;
}

+(NSMutableDictionary*) filter: (NSDictionary*)dictionary filter:(BOOL(^)(id value))filter {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        id value = [dictionary objectForKey: key];
        
        if (filter(value)) continue;
        
        [result setObject: value forKey:key];
    }
    return result;
}

+(NSMutableDictionary*) convertNumberToString: (NSDictionary*)dictionary
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



#pragma mark - About Keys and Values

// For Two Dimension Dictioanry
// i.e :
// { "HumanResource":{"EmployeeCHOrder":["YGYDB201312181638"],"Employee":[]},  "Finance":{"FinanceSalaryCHOrder":[]}, } -> {"EmployeeCHOrder":["YGYDB201312181638"], "Employee":[], "FinanceSalaryCHOrder":[]}
+(NSMutableDictionary*) convertToOneDimensionDictionary: (NSDictionary*)dictionary
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (id key in dictionary) {
        NSDictionary* value = [dictionary objectForKey: key];
        for (NSString* subKey in value) {
            id subValue = [value objectForKey: subKey];
            [result setObject: subValue forKey:subKey];
        }
    }
    return result;
}


+(NSMutableDictionary*) convert: (NSArray*)values keys:(NSArray*)keys
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < values.count; i++) {
        id obj = values[i];
        [dictionary setObject: obj forKey:keys[i]];
    }
    return dictionary.count ? dictionary : nil;
}


#pragma mark - Get the depth
// dictionary with dictionary in it.
+(NSInteger) getTheDepth: (NSDictionary*)dictionary
{
    NSInteger depth = 1 ;
    [self iterateDictionary: dictionary depth:&depth];
    return depth;
}
// so to be optimize
+(void) iterateDictionary: (NSDictionary*)dictionary depth:(NSInteger*)depth
{
    *depth = *depth + 1;
    for (NSString* key in dictionary) {
        id content = dictionary[key];
        if ([content isKindOfClass:[NSDictionary class]]) {
            [self iterateDictionary: content depth:depth];
            break;      // just get one to test , so , you must has the same structure in it.
        }
    }
}


@end
