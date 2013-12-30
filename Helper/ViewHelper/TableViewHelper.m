#import "TableViewHelper.h"


@implementation TableViewHelper

+(NSIndexPath*) getLastIndexPath: (UITableView*)tableView
{
    int lastSection = tableView.numberOfSections - 1;
    return [self getLastIndexPath: tableView inSection:lastSection];
}

+(NSIndexPath*) getLastIndexPath: (UITableView*)tableView inSection: (NSUInteger)section
{
    int lastRow = [tableView numberOfRowsInSection: section] - 1;
    return [NSIndexPath indexPathForRow: lastRow inSection:section];
}

+(NSIndexPath*) getIndexPath: (UITableView*)tableView cellSubView:(UIView*)subview
{
    // get table cell

    UITableViewCell* cell = [TableViewHelper getTableViewCell: tableView cellSubView:subview];
    // get the index path
    NSIndexPath* indexPath = [tableView indexPathForCell: cell];
    return indexPath;
}

// get cell by cell's subview
+(UITableViewCell*) getTableViewCell: (UITableView*)tableView cellSubView:(UIView*)subview
{
    // get table cell
    UITableViewCell* cell = (UITableViewCell*)[subview superview];
    while (cell && ![cell isKindOfClass:[UITableViewCell class]]) cell = (UITableViewCell*)[cell superview];
    return cell;
}


@end
