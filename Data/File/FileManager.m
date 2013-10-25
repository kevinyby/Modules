#import "FileManager.h"

#define NSFileManagerInstance [NSFileManager defaultManager]

#define tmp @"tmp"


@implementation FileManager


+(NSString*) tmpPath {
//    return NSTemporaryDirectory();        // the has the suffix "/"
    return [NSHomeDirectory() stringByAppendingPathComponent: tmp];
}

+(NSString*) homePath {
    return NSHomeDirectory();
}

+(NSString*) libraryPath {
    return [NSHomeDirectory() stringByAppendingPathComponent: Library];
}

+(NSString*) documentsPath {
    return [NSHomeDirectory() stringByAppendingPathComponent: Documents];
}

+(void) deleteFile: (NSString*)fullPath {
    NSError* error = nil;
    [NSFileManagerInstance removeItemAtPath: fullPath error:&error];
}

+(BOOL) isFileExist: (NSString*)fullPath {
    return ([NSFileManagerInstance fileExistsAtPath:fullPath]);
}

+(void) writeDataToDocument: (NSString*)filename data:(NSData*)data {
    NSString* fullPath = [[self documentsPath] stringByAppendingPathComponent: filename];
    [self saveDataToFile: fullPath data:data];
}

+(NSData*) getDataFromDocument: (NSString*)filename {
    NSString* fullPath = [[self documentsPath] stringByAppendingPathComponent: filename];
    return [NSData dataWithContentsOfFile: fullPath];
}

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath {
    NSError* error = nil;
    NSArray *files = [NSFileManagerInstance contentsOfDirectoryAtPath:directoryPath error:&error];
    NSMutableArray* filePaths = [NSMutableArray array];
    for (NSString* file in files) {
        NSString* path = [directoryPath stringByAppendingPathComponent: file];
        if (path) [filePaths addObject: path];
    }
    return filePaths;
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
}


#pragma mark - Not Explicit	Public Methods

+(void) saveDataToFile: (NSString*)fullPath data:(NSData*)data {
    [self createFolderIfNotExist:fullPath];
    [data writeToFile: fullPath atomically:NO];
}



@end
