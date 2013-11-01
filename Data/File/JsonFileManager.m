#import "JsonFileManager.h"

@implementation JsonFileManager

/** @return Could be NSDictionary or NSArray */
+(id) getJson: (NSString*)jsonFileName
{
    NSString* jsonFilePath = JSONFILE_PATH(jsonFileName);
    NSData* jsonData = [NSData dataWithContentsOfFile: jsonFilePath];
    NSError* error = nil;
    id content = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        NSString* message = [NSString stringWithFormat:@"Check your %@ json file or json format please", jsonFileName];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"JASON PARSE ERROR"
                                                        message: message
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    return content;
}

@end
