#import "LocalizeFileManager.h"
#import "_Helper.h"

@implementation LocalizeFileManager

/** @prama outterContents two dimensioin dictionary 
 
    outter keys is the file full path
 */
+(void) writeStringsFile: (NSDictionary*)outterContents {
    NSArray* fliePaths = [outterContents allKeys];
    for (NSString* filePath in fliePaths) {
        NSDictionary* contents = [outterContents objectForKey: filePath];
        [LocalizeFileManager writeStringsFile: contents toPath:filePath];
    }
}

/** @prama contents one dimensioin dictionary */
+(void) writeStringsFile: (NSDictionary*)contents toPath:(NSString*)filePath {
    NSError* error = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    BOOL existed = [manager fileExistsAtPath: filePath];
    if (existed) {
        [manager removeItemAtPath: filePath error: &error];
    }
    
    BOOL created = [manager createFileAtPath: filePath contents: nil attributes: nil];
    
    if (created) {
        NSMutableString* stringsFileContents = [[NSMutableString alloc] init];
        NSArray* sorteKeys = [DictionaryHelper getSortedKeys: contents];
        
        // append keys-values
        for (int i = 0; i < sorteKeys.count ; i ++) {
            id key = [sorteKeys objectAtIndex: i];
            NSString* value = [contents objectForKey: key];
            NSString* keyValue = [NSString stringWithFormat: @"\"%@\"=\"%@\";\r\n", key , value];
            [stringsFileContents appendString: keyValue];
        }
        
        // write to file
        [stringsFileContents writeToFile: filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    }
}


/** @return outterContents two dimensioin dictionary
 
 outter keys is the file full path
 */
+(NSMutableDictionary*) readStringsFiles: (NSArray*)filePaths {
    NSMutableDictionary* outterContents = [[NSMutableDictionary alloc] initWithCapacity: 0];
    for( int i = 0; i < filePaths.count; i++){
        NSString* filePath = [filePaths objectAtIndex: i];
        NSMutableDictionary* contents = [self readStringsFile: filePath];
        [outterContents setObject:contents forKey:filePath];
    }
    return outterContents;
}

/** @return the file content */
+(NSMutableDictionary*) readStringsFile: (NSString*)filePath {
    NSString *error = nil; NSPropertyListFormat format ;
    NSData *plistData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *contents = [NSPropertyListSerialization propertyListFromData:plistData
                                                              mutabilityOption:NSPropertyListImmutable
                                                                        format:&format
                                                              errorDescription:&error];
    return [NSMutableDictionary dictionaryWithDictionary: contents];
}

@end
