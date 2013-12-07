#import "TableViewBase.h"

@interface TableViewBaseBlock : TableViewBase

@property (copy) void (^selectActionBlock)(UITableView* tableViewObj, NSIndexPath* indexPath) ;

@end
