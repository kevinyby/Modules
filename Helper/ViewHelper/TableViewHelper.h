#import <Foundation/Foundation.h>

@interface TableViewHelper : NSObject

+(NSIndexPath*) getLastIndexPath: (UITableView*)tableView;

+(NSIndexPath*) getLastIndexPath: (UITableView*)tableView inSection: (NSUInteger)section;

<<<<<<< HEAD
+(NSIndexPath*) getIndexPath: (UITableView*)tableView cellSubView:(UIView*)subview;
=======

+(NSIndexPath*) getIndexPath: (UITableView*)tableView cellSubView:(UIView*)subview;
+(UITableViewCell*) getTableViewCell: (UITableView*)tableView cellSubView:(UIView*)subview;

>>>>>>> e7a8057204d73f85ad73bd5034f4b6d7b4849eaa
@end
