#import <Foundation/Foundation.h>

@class TableViewBase;

@interface TableViewBaseHelper : NSObject

+(void) insertToLastRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSArray*)contents realContent:(id)realContent;

+(void) insertToFirstRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSArray*)contents realContent:(id)realContent;

@end
