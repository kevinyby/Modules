#import "TableViewBase.h"

typedef enum {
    FilterModeContains = 0,
    FilterModeBeginWith = 1,
} FilterMode;

@interface FilterTableView : TableViewBase

@property (strong, nonatomic) NSString* filterText;
@property (assign, nonatomic) FilterMode filterMode;

-(BOOL) isInFilteringMode;
-(NSIndexPath*) traslateIndexPathInFilterMode: (NSIndexPath*)indexPath;

@end
