#import "CSVFileWriter.h"

#import "CHCSVParser.h"
#import "FileManager.h"

@implementation CSVFileWriter


// array contains dictioins , headerFields in the first line , and are the keys of dictionary
+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields {
    [self write:array to:fullPath headerFields:headerFields append:NO];
}

+(void) write: (NSArray*)array to:(NSString*)fullPath headerFields:(NSArray*)headerFields append:(BOOL)append {
    [FileManager createFolderIfNotExist: fullPath];
    NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:fullPath append:append];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:','];
    
    [writer writeLineOfFields:headerFields];
    
    int count = headerFields.count;
    for (NSDictionary *dic in array) {
        
        NSMutableArray* line = [NSMutableArray arrayWithCapacity: count];           // maintain the sequence/order
        for (int i = 0; i < count; i++) {
            id key = [headerFields objectAtIndex: i];
            id value = [dic objectForKey: key];
            [line addObject: value];
        }
        [writer writeLineOfFields:line];
    }
    
    [writer closeStream];
}





/*
 *    arry is two dimensions , e.g.
 @[
 @[@"one",@"two"],
 @[@"A",@"B"]
 ]
 *
 *    fullPath with the filename , e.g. path = "/Document/CVS/content.csv"
 */
+(void) write: (NSArray*)array to:(NSString*)fullPath {
    //	NSLog(@"Writing CSV File : %@", path);
    
    NSOutputStream *output = [NSOutputStream outputStreamToFileAtPath:fullPath append:NO];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:output encoding:NSUTF8StringEncoding delimiter:','];
    
    BOOL isTowDimensions = [[array lastObject] isKindOfClass:[NSArray class]];
    
    if (isTowDimensions) {
        for (NSArray *line in array) {
            [writer writeLineOfFields:line];
        }
    } else {
        [writer writeLineOfFields: array];
    }
    
    [writer closeStream];
}


@end
