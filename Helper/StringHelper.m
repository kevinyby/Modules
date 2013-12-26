#import "StringHelper.h"


#define SPACE_META      @"."
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

+(NSMutableString*) separateChinese:(NSString*)string space:(int)space
{
    NSMutableString* separateString = [[NSMutableString alloc] init];
    
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        
        [separateString appendString: chinese];
        
        if (index != length-1) {        // not the last one
            for (int i = 0; i < space; i++) {
                [separateString appendString: SPACE_STRING];
            }
        }
        
        return NO;
    }];
    return separateString;
}

// space = 1.0 , means every chinese will separate by 1 space
// space = 1.23, means every chinese will separate by 1 space, and the 2nd chinese (tail) will have 3 more space additional.
// space = 0.03, means that every chinese have 0 space , and the 1st (head) will have 3 space . (in this case , prefix will be 3 space)
// space = 0.0345, ...., the 4st (tail) will have 5 space.
+(NSMutableString*) separateChinese:(NSString*)string spaceMeta:(NSString*)spaceMeta
{
    
    NSArray* array = [spaceMeta componentsSeparatedByString: SPACE_META];
    int everyspace = [[array firstObject] intValue];
    
    NSString* tails = [array lastObject];
    
    
    NSMutableString* separateString = [[NSMutableString alloc] init];
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        
        // tails
        if (index == 0) {                   // the first one
            int num = [StringHelper getSpaceNumber: tails index: index];
            for (int i = 0; i < num; i++) {
                [separateString appendString: SPACE_STRING];
            }
        }
        
        
        [separateString appendString: chinese];
        
        
        // every space between word
        if (index != length-1) {            // not the last one
            for (int i = 0; i < everyspace; i++) {
                [separateString appendString: SPACE_STRING];
            }
        }
        
        // tails
        int num = [StringHelper getSpaceNumber: tails index: index+1];
        for (int i = 0; i < num; i++) {
            [separateString appendString: SPACE_STRING];
        }
        
        return NO;
    }];
    return separateString;
}
// util method
+(int) getSpaceNumber: (NSString*)tails index:(int)index
{
    int length = tails.length/2;
    for (int i = 0; i < length; i++) {
        NSString* string = [tails substringWithRange:(NSRange){i*2, 2}];
        
        NSString* seqStr = [string substringWithRange:(NSRange){0,1}];
        NSString* numStr = [string substringWithRange:(NSRange){1,1}];
        
        int seq = [seqStr intValue];
        int num = [numStr intValue];
        
        if (seq == index) return num;
    }
    
    return 0;
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


+(void) iterateChineseWord:(NSString*)string handler:(BOOL(^)(int length, int index, NSString* chinese))handler
{
    int length = string.length;
    for (int i = 0 ; i < string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        
        // chinese
        if (0x4e00 < ch  && ch < 0x9fff) {
            NSString * chinessCharacter = [string substringWithRange:NSMakeRange(i, 1)];
            if(handler(length, i, chinessCharacter)) return;
        }
    }
}

@end
