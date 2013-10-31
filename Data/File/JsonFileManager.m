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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"JASON PARSE ERROR"
                                                        message: @"Check your json file or json format please "
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    return content;
}


+(CGRect) convertToRect: (NSArray *)rectArray
{
    return CGRectMake([[rectArray objectAtIndex: 0] floatValue],
                      [[rectArray objectAtIndex: 1] floatValue],
                      [[rectArray objectAtIndex: 2] floatValue],
                      [[rectArray objectAtIndex: 3] floatValue]);
}

@end
