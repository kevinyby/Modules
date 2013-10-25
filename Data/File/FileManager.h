#import <Foundation/Foundation.h>


#define Library @"Library"

#define Documents @"Documents"


@interface FileManager : NSObject {
}

// in the last path string do not have "/"
// in the other word , character "/" is not the tail
+(NSString*) tmpPath ;
+(NSString*) homePath ;
+(NSString*) libraryPath ;
+(NSString*) documentsPath ;

+(void) deleteFile: (NSString*)fullPath ;

+(BOOL) isFileExist: (NSString*)fullPath ;

+(void) createFolderIfNotExist: (NSString*)fullPath ;

// file name can be "/abc/hot.png", the will save to "Documents/abc/hot.png"
+(NSData*) getDataFromDocument: (NSString*)filename ;
+(void) writeDataToDocument: (NSString*)filename data:(NSData*)data ;

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath ;

    
@end
