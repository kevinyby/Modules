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

@end
