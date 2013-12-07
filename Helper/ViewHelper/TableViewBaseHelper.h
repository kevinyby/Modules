#import <Foundation/Foundation.h>

@class TableViewBase;

@interface TableViewBaseHelper : NSObject

+(void) insertToLastRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSString*)content realContent:(id)realContent;

@end
