#import "TableViewBaseBlock.h"

@implementation TableViewBaseBlock

- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectActionBlock) {
        self.selectActionBlock(tableViewObj,indexPath);
    } else {
        [super tableView: tableViewObj didSelectRowAtIndexPath:indexPath];
    }
}

@end
