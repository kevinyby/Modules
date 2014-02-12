#import "TableViewBase.h"

typedef enum {
    FilterModeContains = 0,
    FilterModeBeginWith = 1,
} FilterMode;

@interface FilterTableView : TableViewBase

@property (assign) BOOL disable;
@property (strong, nonatomic) NSString* filterText;
@property (assign, nonatomic) FilterMode filterMode;
@property (strong) NSIndexPath* seletedVisibleIndexPath;        // when did selected, in filter is the filter index path , in real mode is the real index path

-(BOOL) isInFilteringMode;
-(NSIndexPath*) getRealIndexPath:(UIView*)subview ;
-(NSIndexPath*) traslateFilterModeIndexPath: (NSIndexPath*)indexPath;

@end
