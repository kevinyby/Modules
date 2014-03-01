#import "FileManager.h"

#include <sys/xattr.h>  // for addSkipBackupAttributeToItemAtURL: method


#define NSFileManagerInstance [NSFileManager defaultManager]

#define Library @"Library"

#define Documents @"Documents"


@implementation FileManager

#pragma mark - Path

+(NSString*) tempPath: (NSString*)subPath {
    NSString* tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:subPath];
    return tempFilePath;
}

+(NSString*) homePath {
    return NSHomeDirectory();
}

+(NSString*) libraryPath {
    return [NSHomeDirectory() stringByAppendingPathComponent: Library];
}

+(NSString*) documentsPath {
//    return [NSHomeDirectory() stringByAppendingPathComponent: Documents];
    NSArray* documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    return [documentsPaths firstObject];
}

+(NSString*) libraryCachesPath: (NSString*)subPath {
    return [[[self libraryPath] stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:subPath];
}

#pragma mark - Delete, Copy, Save, Move , Create , Check Exist ...

+(NSError*) deleteFile: (NSString*)fullPath {
    NSError* error = nil;
    [NSFileManagerInstance removeItemAtPath: fullPath error:&error];
    return error;
}

+(NSError*) copyFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath {
    NSError* error = nil;
    [self createFolderIfNotExist:fileDesFullPath];
    [NSFileManagerInstance copyItemAtPath: fileSrcFullPath toPath:fileDesFullPath error:&error];
    
    // TODO: Check out what does it means
    NSURL* url = [NSURL URLWithString:fileDesFullPath];
    [self addSkipBackupAttributeToItemAtURL:url];
    
    return error;
}

+(void) saveDataToFile: (NSString*)fullPath data:(NSData*)data {
    [self createFolderIfNotExist: fullPath];
    [NSFileManagerInstance createFileAtPath:fullPath contents:data attributes:nil];

//    [data writeToFile: fullPath atomically:NO];   // Another way. TODO: Check different
    
    // TODO: Check out what does it means
    NSURL* url = [NSURL URLWithString:fullPath];
    [self addSkipBackupAttributeToItemAtURL:url];
}

+(NSError*) moveFile: (NSString*)fileSrcFullPath to:(NSString*)fileDesFullPath {
    NSError* error = nil;
    [self createFolderIfNotExist:fileDesFullPath];
    [NSFileManagerInstance moveItemAtPath:fileSrcFullPath toPath:fileDesFullPath error:&error];
    
    // TODO: Check out what does it means
    NSURL* url = [NSURL URLWithString:fileDesFullPath];
    [self addSkipBackupAttributeToItemAtURL:url];
    return error;
}

+(void) createFolderIfNotExist: (NSString*)fullPath {
    NSError* error = nil;
    
    if(![self isFileExist: fullPath]) {
        // file not exists
        NSString* directoryPath = [fullPath stringByDeletingLastPathComponent];
        if(![NSFileManagerInstance fileExistsAtPath:directoryPath]) {
            // dir not exists, create it
            [NSFileManagerInstance createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    
    if(error){
        NSLog(@"Failed when create %@ ", fullPath);
    }
}

+(BOOL) isFileExist: (NSString*)fullPath {
    return ([NSFileManagerInstance fileExistsAtPath:fullPath]);
}

#pragma mark - Read & Write Data

+(void) writeDataToDocument: (NSString*)filename data:(NSData*)data {
    NSString* fullPath = [[self documentsPath] stringByAppendingPathComponent: filename];
    [self saveDataToFile: fullPath data:data];
}

+(NSData*) getDataFromDocument: (NSString*)filename {
    NSString* fullPath = [[self documentsPath] stringByAppendingPathComponent: filename];
    return [NSData dataWithContentsOfFile: fullPath];
}

+(NSArray*) getFileNamesIn:(NSString*)directoryPath{
    NSError* error = nil;
    NSArray* files = [NSFileManagerInstance contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error != nil){
        NSLog(@"getFIleNamesIn: error");
        return nil;
    }
    
    return files;
}

+(NSData*) getFileWithPath:(NSString*)path{
    return [NSData dataWithContentsOfFile:path];
}

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath {
    NSArray *files = [self getFileNamesIn:directoryPath];
    NSMutableArray* filePaths = [NSMutableArray array];
    for (NSString* file in files) {
        NSString* path = [directoryPath stringByAppendingPathComponent: file];
        if (path) [filePaths addObject: path];
    }
    return filePaths;
}



#pragma mark - Util Methods
// TODO: Check out what does it means
+(BOOL) addSkipBackupAttributeToItemAtURL: (NSURL *)URL {
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}



@end
