#import "TableViewBase.h"

typedef enum {
    FilterModeContains = 0,
    FilterModeBeginWith = 1,
} FilterMode;

@interface FilterTableView : TableViewBase

@property (strong, nonatomic) NSString* filterText;
@property (assign, nonatomic) FilterMode filterMode;
@property (assign) BOOL disable;

-(BOOL) isInFilteringMode;
-(NSIndexPath*) traslateIndexPathInFilterMode: (NSIndexPath*)indexPath;

@end
