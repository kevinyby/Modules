#import "TableViewBaseHelper.h"

#import "TableViewBase.h"

#import "_Helper.h"

@implementation TableViewBaseHelper


+(void) insertToLastRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSString*)content realContent:(id)realContent
{
    // insert data
    NSMutableArray* sectionsContents = [tableView contentsForSection: section];
    NSMutableArray* realSectionsContents = [tableView realContentsForSection: section];
    
    // check if already has
    if ([sectionsContents contains: content])
    {
        int row = [sectionsContents index: content];
        NSIndexPath* containsIndexPath = [NSIndexPath indexPathForRow: row inSection:section];
        [tableView selectRowAtIndexPath:containsIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        return;
    }
    
    int maxRow = sectionsContents.count - 1;
    
    [sectionsContents insertObject: content atIndex: maxRow ];
    [realSectionsContents insertObject: realContent atIndex:maxRow];
    
    // animation
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow: maxRow inSection:section]] withRowAnimation:UITableViewRowAnimationBottom];
    
    // scroll to bottom
    [tableView scrollToRowAtIndexPath: [TableViewHelper getLastIndexPath: tableView] atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

@end
