#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

+(int) numberOfUpperCaseCharacter: (NSString*)string ;

+(BOOL) isContainsChinese:(NSString*)string;

+(NSMutableString*) getChinese:(NSString*)string;

+(NSMutableString*) insertSpace: (NSString*)string atIndex:(NSUInteger)index spaceCount:(NSUInteger)spaceCount;

+(NSMutableString*) separate:(NSString*)string spaceMeta:(NSString*)spaceMeta;

@end
