#import <Foundation/Foundation.h>

@interface FileManager : NSObject {
}

#pragma mark - Path
// in the last path string do not have "/"
// in the other word , character "/" is not the tail
/** Use stringByAppendingPathComponent: , you really no need to care about this*/
+(NSString*) tempPath: (NSString*)subPath ;
+(NSString*) homePath ;
+(NSString*) libraryPath ;
+(NSString*) documentsPath ;

+(NSString*) libraryCachesPath: (NSString*)subPath ;

#pragma mark - Delete , Copy , Move , Create , Check Exist ...
+(NSError*) deleteFile: (NSString*)fullPath ;

+(NSError*) copyFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath ;
+(void) saveDataToFile: (NSString*)fullPath data:(NSData*)data ;
+(NSError*) moveFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath ;

+(void) createFolderIfNotExist: (NSString*)fullPath ;
+(BOOL) isFileExist: (NSString*)fullPath ;


// file name like "/abc/hot.png", will be saved to "Documents/abc/hot.png"
+(NSData*) getDataFromDocument: (NSString*)filename ;
+(void) writeDataToDocument: (NSString*)filename data:(NSData*)data ;

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath ;
+(NSArray*) getFileNamesIn:(NSString*)directoryPath;


#pragma mark - Util Methods

+(BOOL) addSkipBackupAttributeToItemAtURL: (NSURL *)URL ;
    
@end
