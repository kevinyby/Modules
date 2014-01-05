#import "JsonFileManager.h"

#define JSON_EXTENTION @"json"

#if defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define __PLATFORM_IPHONE_OS
#else
#define __PLATFORM_MAC_X_OS
#endif

#ifdef __PLATFORM_IPHONE_OS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation JsonFileManager

/** @return Could be NSDictionary or NSArray */
+(id) getJsonFromFile: (NSString*)jsonFileName
{
    jsonFileName = [[jsonFileName pathExtension] length] == 0 ? [jsonFileName stringByAppendingPathExtension: JSON_EXTENTION] : jsonFileName;
    NSString* jsonFilePath = BUNDLEFILE_PATH(jsonFileName);
    return [JsonFileManager getJsonFromPath: jsonFilePath];
}


+(id) getJsonFromPath: (NSString*)jsonFilePath
{
    NSData* jsonData = [NSData dataWithContentsOfFile: jsonFilePath];
    NSError* error = nil;
    id content = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingAllowFragments error:&error];
    
#ifdef __PLATFORM_IPHONE_OS
    if (error) {
        NSString* message = [NSString stringWithFormat:@"Check your %@ json file or json format please", [jsonFilePath lastPathComponent]];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"JASON PARSE ERROR"
                                                        message: message
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
#else
    if (error) {
        NSString* message = [NSString stringWithFormat:@"Check your %@ json file or json format please", jsonFileName];
        NSRunAlertPanel(@"JASON PARSE ERROR", message, @"OK", nil, nil);
    }
#endif
    
    return content;
}

@end
