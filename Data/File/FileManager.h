#import <Foundation/Foundation.h>


#define Library @"Library"

#define Documents @"Documents"


@interface FileManager : NSObject {
}

+(NSString*) tmpPath ;
+(NSString*) homePath ;
+(NSString*) libraryPath ;
+(NSString*) documentsPath;

+(BOOL) ifFileExist: (NSString*)fullPath ;
+(void) saveDataToDocumentWithSubPath: (NSString*)subPath data:(NSData*)data ;

+(NSMutableArray*) getFilesPathsIn: (NSString*)directoryPath ;

    
@end
