#import <UIKit/UIKit.h>


@class TableViewBase;


//_______________________________________________________________________________________________________________

@protocol TableViewBaseTableProxy <NSObject>

@optional

// UITableViewDataSource
- (UITableViewCell*)tableViewBase:(TableViewBase *)tableViewObj cellForIndexPath:(NSIndexPath *)indexPath oldCell:(UITableViewCell*)oldCell;

- (BOOL)tableViewBase:(TableViewBase *)tableViewObj canEditIndexPath:(NSIndexPath*)indexPath;

- (void)tableViewBase:(TableViewBase *)tableViewObj commitEditStyle:(UITableViewCellEditingStyle)editStyle indexPath:(NSIndexPath *)indexPath;

- (BOOL)tableViewBase:(TableViewBase *)tableViewObj shouldDeleteContentsAtIndexPath:(NSIndexPath*)indexPath;

- (void)tableViewBase:(TableViewBase *)tableViewObj didDeleteContentsAtIndexPath:(NSIndexPath*)indexPath;


// UITableViewDelegate
- (void)tableViewBase:(TableViewBase *)tableViewObj didSelectIndexPath:(NSIndexPath*)indexPath;

- (void)tableViewBase:(TableViewBase *)tableViewObj willShowCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath;

- (CGFloat)tableViewBase:(TableViewBase *)tableViewObj heightForSection:(NSInteger)section;

- (CGFloat)tableViewBase:(TableViewBase *)tableViewObj heightForIndexPath:(NSIndexPath*)indexPath;

// Edit Pair Extendions :
- (NSString*)tableViewBase:(TableViewBase *)tableViewObj titleForDeleteButtonAtIndexPath:(NSIndexPath*)indexPath;

@end


//_______________________________________________________________________________________________________________

@protocol TableViewBaseScrollProxy <NSObject>

@optional

// UIScrollViewDelegate
- (void)tableViewBaseDidScroll:(TableViewBase *)tableViewObj ;

- (void)tableViewBase:(TableViewBase *)tableViewObj didEndDragging:(BOOL)willDecelerate;

@end





//_______________________________________________________________________________________________________________

@interface TableViewBase : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(assign) BOOL hideSections;
@property(strong, readonly) NSString* cellReuseIdentifier;

@property(assign) id<TableViewBaseTableProxy> proxy;
@property(assign) id<TableViewBaseScrollProxy> scrollProxy;     // For RefreshTableView now

// "_l" for "_local"

// if keysMap == nil , asume that the keys is the same!!!!
// @{@"section_1_l" : @"section_1", @"section_2_l":@"section_2" }
@property(strong) NSMutableDictionary* keysMap;

// { @"section_1":@[[@"1",@"2",@"3"],[@"1",@"2",@"3"]], @"section_2":@[[@"1",@"2",@"3"],[@"1",@"2",@"3"]] };
// the background/real data of contentsDictionary, be sure has the same sort/order/sequence contentsDictionary
@property (strong) NSMutableDictionary* realContentsDictionary;

// { @"section_1_l":@[[@"1_l",@"2_l",@"3_l"],[@"1_l",@"2_l",@"3_l"]], @"section_2_l":@[[@"1_l",@"2_l",@"3_l"],[@"1_l",@"2_l",@"3_l"]] };
// the show/visible contents to end-user, be sure has the same sort/order/sequence realContentsDictionary
@property(strong, nonatomic) NSMutableDictionary* contentsDictionary;



/** get the sequential keys of contentsDictionary, against to the table section */
-(NSArray *)sections;

/** get the realValue By indexPath */
-(id) realContentForIndexPath: (NSIndexPath*)indexPath;
/** the visible content by indexPath, equals to the cell.textLabel.text */
-(NSString*) contentForIndexPath: (NSIndexPath*)indexPath;

-(NSMutableArray*) contentsForSection: (NSUInteger)section;
-(NSMutableArray*) realContentsForSection: (NSUInteger)section;



#pragma mark - Util Methods
-(void) deleteIndexPath: (NSIndexPath*)indexPath;

@end





//_______________________________________________________________________________________________________________


@interface TableViewBase (ActionBlock)

// To Be Extended ...

// UITableViewDataSource
@property (copy) UITableViewCell* (^tableViewBaseCellForIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath,UITableViewCell* oldCell);
@property (copy) BOOL (^tableViewBaseCanEditIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) void (^tableViewBaseCommitEditStyleAction)(TableViewBase* tableViewObj, UITableViewCellEditingStyle editStyle, NSIndexPath* indexPath);


@property (copy) BOOL (^tableViewBaseShouldDeleteContentsAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) void (^tableViewBaseDidDeleteContentsAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);

// UITableViewDelegate
@property (copy) void (^tableViewBaseWillShowCellAction)(TableViewBase* tableViewObj,UITableViewCell* cell, NSIndexPath* indexPath);
@property (copy) void (^tableViewBaseDidSelectAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) CGFloat(^tableViewBaseHeightForSectionAction)(TableViewBase* tableViewObj,NSInteger section);
@property (copy) CGFloat(^tableViewBaseHeightForIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
@property (copy) NSString*(^tableViewBaseTitleForDeleteButtonAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);

@end


