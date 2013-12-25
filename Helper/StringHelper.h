#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

+(int) numberOfUpperCaseCharacter: (NSString*)string ;

+(NSMutableString*) separateChinese:(NSString*)string spaceCount:(int)spaceCount;

+(NSMutableString*) insertSpace: (NSString*)string atIndex:(NSUInteger)index spaceCount:(NSUInteger)spaceCount;

@end
