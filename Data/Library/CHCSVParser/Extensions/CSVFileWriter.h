#import <Foundation/Foundation.h>

@interface CSVFileWriter : NSObject

/** array contains dictioins , headerFields in the first line , and are the keys of dictionary*/
+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields ;
+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields append:(BOOL)append ;



/**
    @param  arry is two dimensions , e.g.
 @[
 @[@"one",@"two"],
 @[@"A",@"B"]
 ]
   @param  fullPath with the filename , e.g. path = "/Document/CVS/content.csv"
 */
+(void) write: (NSArray*)array to:(NSString*)fullPath ;

@end
