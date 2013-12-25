#import "StringHelper.h"


#define SPACE_STRING @" "


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

+(NSMutableString*) separateChinese:(NSString*)string spaceCount:(int)spaceCount
{
    NSMutableString* separateString = [[NSMutableString alloc] init];
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        [separateString appendString: chinese];
        
        if (index != length-1) {        // not the last one
            for (int i = 0; i < spaceCount; i++) {
                [separateString appendString: SPACE_STRING];
            }
        }
        return NO;
    }];
    return separateString;
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
