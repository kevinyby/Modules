#import "StringHelper.h"

@implementation StringHelper

+(int) numberOfUpperCaseCharacter: (NSString*)string {
    int count = 0;
    for (int i = 0; i < [string length]; i++) {
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:i]];
        if (isUppercase == YES) count++;
    }
    return count;
}

@end
