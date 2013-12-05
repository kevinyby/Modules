#import <Foundation/Foundation.h>

@interface TableViewHelper : NSObject

+(NSIndexPath*) getLastIndexPath: (UITableView*)tableView;

+(NSIndexPath*) getLastIndexPath: (UITableView*)tableView inSection: (NSUInteger)section;

@end
