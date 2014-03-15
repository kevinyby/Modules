#import "TableContentHelper.h"

// _Helper.h
#import "IterateHelper.h"
#import "DictionaryHelper.h"

// _View.h
#import "AlignTableView.h"

@implementation TableContentHelper


+(NSString*) getStringValue: (id)value
{
    NSString* text = nil;
    if ([value isKindOfClass: [NSString class]]) text = value;
    else if ([value isKindOfClass: [NSNumber class]]) text = [value stringValue];
    return text;
}


#pragma mark - Handler Real Content Dictionary

+(NSMutableDictionary*) assembleToRealContentDictionary: (NSArray*)objects keys:(NSArray*)keys {
    NSMutableDictionary* realContentsDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < objects.count; i++) {
        NSArray* modelObjects = [objects objectAtIndex: i];
        NSArray* contents = [self assembleToSectionContents: modelObjects];
        [realContentsDictionary setObject: contents forKey:keys[i]];
    }
    return realContentsDictionary;
}
+(NSMutableArray*) assembleToSectionContents: (NSArray*)modelObjects {
    NSMutableArray* contents = [NSMutableArray array];
    for (int j = 0; j < modelObjects.count; j++) {
        NSArray* fieldValues = [modelObjects objectAtIndex: j];
        NSArray* cellValues = [self assembleToCellValues: fieldValues];
        [contents addObject: cellValues];
    }
    return contents;
}
+(NSMutableArray*) assembleToCellValues: (NSArray*)fieldValues {
    NSMutableArray* cellValues = [NSMutableArray array];
    for (int e = 0; e < fieldValues.count; e++) {
        id atom = [fieldValues objectAtIndex: e];
        [cellValues addObject: atom];
    }
    return cellValues;
}

#pragma mark - Iterate real content dictionary

/**
 *  @param dictionary the dic with nsarray in it
 *  @param handler               inner handler
 */
+(void) iterate: (NSDictionary*)realContentsDictionary handler:(BOOL (^)(id key, int row, id value))handler
{
    NSArray* keys = [DictionaryHelper getSortedKeys: realContentsDictionary];
    for (NSString* key in keys) {
        NSArray* sections = realContentsDictionary[key];
        for (int row = 0; row < sections.count; row++) {
            id cellValue = sections[row];                 // maybe nsarray , may be nsstring, or anything , decide by u pass the dictionary
            if(handler(key, row, cellValue)) return;
        }
    }
}




#pragma mark - Util - iterate and return the new contents dictionary
// handler: int index, int outterCount, NSString* section, NSArray* cellValues, NSMutableArray* sectionRep
+(NSMutableDictionary*) iterateContentsDictionaryToSection: (NSDictionary*)contentDictionary handler:(void (^)(int, int, NSString*, NSArray*, NSMutableArray*))handler
{
    NSArray* keys = [DictionaryHelper getSortedKeys: contentDictionary];
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    [IterateHelper iterate: keys handler:^BOOL(int index, id section, int count) {
        NSArray* sectionContents = [contentDictionary objectForKey: section];
        NSMutableArray* newSectionContents = [NSMutableArray array];
        [IterateHelper iterate: sectionContents handler:^BOOL(int index, id obj, int count) {
            if (handler) handler(index, count, section,  obj, newSectionContents);
            return NO;
        }];
        [newDictionary setObject: newSectionContents forKey:section];
        return NO;
    }];
    return newDictionary;
}


// handler:  int index, int innerCount, int outterCount, NSString* section, id obj, NSMutableArray* cellRep
+(NSMutableDictionary*) iterateContentsDictionaryToCell: (NSDictionary*)contentDictionary handler:(void (^)(int, int, int, NSString*, id, NSMutableArray*))handler
{
    return [self iterateContentsDictionaryToSection:contentDictionary handler:^(int index, int outterCount, NSString* section, NSArray *cellValues, NSMutableArray *sectionRep) {
        
        NSMutableArray* newCellValues = [NSMutableArray array];
        [IterateHelper iterate: cellValues handler:^BOOL(int index, id cellValue, int count) {
            if (handler) handler(index, count, outterCount, section, cellValue, newCellValues);
            return NO;
        }];
        [sectionRep addObject: newCellValues];
        
    }];
}


@end
