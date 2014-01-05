#import "StringHelper.h"


#define SPACE_META_CONNECTOR      @"|"
#define SPACE_TAIL_CONNECTOR      @","
#define SPACE_ATOM_CONNECTOR      @"."

#define SPACE_STRING    @" "


@implementation StringHelper

+(int) numberOfUpperCaseCharacter: (NSString*)string {
    int count = 0;
    for (int i = 0; i < [string length]; i++) {
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:i]];
        if (isUppercase == YES) count++;
    }
    return count;
}

#pragma mark -
+(BOOL) isContainsChinese:(NSString*)string
{
    __block BOOL result = NO;
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        result = YES;
        return YES;
    }];
    return result;
}
+(NSMutableString*) getChinese:(NSString*)string
{
    NSMutableString* chineseString = [[NSMutableString alloc] init];
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        [chineseString appendString: chinese];
        return NO;
    }];
    return chineseString;
}

+(NSMutableString*) insertSpace: (NSString*)string atIndex:(NSUInteger)index spaceCount:(NSUInteger)spaceCount
{
    NSMutableString* newString = [[NSMutableString alloc] initWithString: string];
    NSMutableString* spaceString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0 ; i < spaceCount; i++) {
        [spaceString appendString: SPACE_STRING];
    }
    [newString insertString: spaceString atIndex:index];
    return newString;
}


#pragma mark -

// space = 1, means every chinese will separate by 1 space
// space = 1|23, means every chinese will separate by 1 space, and the 2nd chinese (tail) will have 3 more space additional.
// space = 0|03, means that every chinese have 0 space , and the 1st (head) will have 3 space . (in this case , prefix will be 3 space)
// space = 0|0.3,4.5, ...., the 4st (tail) will have 5 space.
+(NSMutableString*) separate:(NSString*)string spaceMeta:(NSString*)spaceMeta
{
    NSArray* array = [spaceMeta componentsSeparatedByString: SPACE_META_CONNECTOR];
    int everyspace = [[array firstObject] intValue];
    NSArray* tails = array.count == 2 ? [[array lastObject] componentsSeparatedByString:SPACE_TAIL_CONNECTOR] : nil;
    
    NSMutableString* separateString = [[NSMutableString alloc] init];
    BOOL isChinese = [StringHelper isContainsChinese: string];
    if (isChinese) {                                                                // Here , has to be optimized
        [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *word) {
            [StringHelper appendSpace: separateString space:everyspace tails:tails length:length index:index word:word];
            return NO;
        }];
    } else {
        [StringHelper iterateEnglishWord: string handler:^BOOL(int length, int index, NSString *word) {
            [StringHelper appendSpace: separateString space:everyspace tails:tails length:length index:index word:word];
            return NO;
        }];
    }
    return separateString;
}

#pragma mark -

// util method
+(void) appendSpace: (NSMutableString*)separateString space:(int)space tails:(NSArray*)tails length:(int)length index:(int)index word:(NSString*)word
{
    // tails
    if (index == 0) {                   // the first one
        int num = [StringHelper getSpaceNumber: tails index: index];
        for (int i = 0; i < num; i++) {
            [separateString appendString: SPACE_STRING];
        }
    }
    
    
    [separateString appendString: word];
    
    
    // every space between word
    if (index != length-1) {            // not the last one
        for (int i = 0; i < space; i++) {
            [separateString appendString: SPACE_STRING];
        }
    }
    
    // tails
    int num = [StringHelper getSpaceNumber: tails index: index+1];
    for (int i = 0; i < num; i++) {
        [separateString appendString: SPACE_STRING];
    }
}

+(int) getSpaceNumber: (NSArray*)tails index:(int)index
{
    int length = tails.count;
    for (int i = 0; i < length; i++) {
        NSString* string = tails[i];
        NSArray* atoms = [string componentsSeparatedByString:SPACE_ATOM_CONNECTOR];
        
        NSString* seqStr = [atoms firstObject];
        NSString* numStr = [atoms lastObject];
        
        int seq = [seqStr intValue];
        int num = [numStr intValue];
        
        if (seq == index) return num;
    }
    
    return 0;
}


+(void) iterateChineseWord:(NSString*)string handler:(BOOL(^)(int length, int index, NSString* chinese))handler
{
    int length = string.length;
    for (int i = 0 ; i < length; i++) {
        unichar ch = [string characterAtIndex:i];
        
        // chinese
        if (0x4e00 < ch  && ch < 0x9fff) {
            NSString * chinessCharacter = [string substringWithRange:NSMakeRange(i, 1)];
            if(handler(length, i, chinessCharacter)) return;
        }
    }
}

+(void) iterateEnglishWord: (NSString*)string handler:(BOOL(^)(int length, int index, NSString* word))handler
{
    NSArray* array = [string componentsSeparatedByString: SPACE_STRING];
    int length = array.count;
    for (int i = 0; i < array.count; i++) {
        NSString* word = array[i];
        if(handler(length, i, word)) return;
    }
}

@end
