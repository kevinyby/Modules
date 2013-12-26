#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

+(int) numberOfUpperCaseCharacter: (NSString*)string ;

+(NSMutableString*) separateChinese:(NSString*)string space:(int)space;

+(NSMutableString*) separateChinese:(NSString*)string spaceMeta:(NSString*)spaceMeta;

+(NSMutableString*) insertSpace: (NSString*)string atIndex:(NSUInteger)index spaceCount:(NSUInteger)spaceCount;

@end
