#import "TableViewBaseHelper.h"

#import "TableViewBase.h"

#import "_Helper.h"

@implementation TableViewBaseHelper


+(void) insertToLastRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSArray*)contents realContent:(id)realContent
{
    // insert data
    NSMutableArray* sectionsContents = [tableView contentsForSection: section];
    NSMutableArray* realSectionsContents = [tableView realContentsForSection: section];
    
    // check if already has
    if ([sectionsContents contains: contents])
    {
        int row = [sectionsContents index: contents];
        NSIndexPath* containsIndexPath = [NSIndexPath indexPathForRow: row inSection:section];
        [tableView selectRowAtIndexPath:containsIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        return;
    }
    
    int row = sectionsContents.count ? sectionsContents.count - 1 : 0;      // get the last row
    
    [sectionsContents insertObject: contents atIndex: row ];
    [realSectionsContents insertObject: realContent atIndex:row];
    
    // animation
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: row inSection:section]] withRowAnimation:UITableViewRowAnimationBottom];
    
    // scroll to bottom
    [tableView scrollToRowAtIndexPath: [TableViewHelper getLastIndexPath: tableView] atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


// just copy the above ...
+(void) insertToFirstRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSArray*)contents realContent:(id)realContent
{
    // insert data
    NSMutableArray* sectionsContents = [tableView contentsForSection: section];
    NSMutableArray* realSectionsContents = [tableView realContentsForSection: section];
    
    // check if already has
    if ([sectionsContents contains: contents])
    {
        int row = [sectionsContents index: contents];
        NSIndexPath* containsIndexPath = [NSIndexPath indexPathForRow: row inSection:section];
        [tableView selectRowAtIndexPath:containsIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        return;
    }
    
    int row =  0;
    
    [sectionsContents insertObject: contents atIndex: row ];
    [realSectionsContents insertObject: realContent atIndex:row];
    
    // animation
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: row inSection:section]] withRowAnimation:UITableViewRowAnimationBottom];
    
}

@end
