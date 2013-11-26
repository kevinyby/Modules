#import <UIKit/UIKit.h>


@class TableViewBase;

@protocol TableViewTableProxy <NSObject>


@optional

- (void)didSelectIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

- (void)willShowIndexPath:(NSIndexPath*)indexPath withCell:(UITableViewCell*)cell on:(TableViewBase *)tableViewObj;

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;


- (UITableViewCell*)cellForIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

@end







@protocol TableViewScrollProxy <NSObject>

@optional

- (void)didScroll:(TableViewBase *)tableViewObj;

- (void)didEndDragging:(BOOL)willDecelerate on:(TableViewBase *)tableViewObj;


@end







@interface TableViewBase : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(assign) id<TableViewTableProxy> proxy;

@property(assign) id<TableViewScrollProxy> scrollProxy;     // For RefreshTableView now

@property(assign) BOOL hideSections;

// Note ,the keys is the same!!!!

// { @"section_1":@[[@"1",@"2",@"3"],[@"1",@"2",@"3"]], @"section_2":@[[@"1",@"2",@"3"],[@"1",@"2",@"3"]] };
@property (strong) NSMutableDictionary* realContentsDictionary;    // the background/real data of contentsDictionary, be sure has the same sort/order/sequence contentsDictionary

// { @"section_1":@[[@"1_l",@"2_l",@"3_l"],[@"1_l",@"2_l",@"3_l"]], @"section_2":@[[@"1_l",@"2_l",@"3_l"],[@"1_l",@"2_l",@"3_l"]] };
@property(strong, nonatomic) NSMutableDictionary* contentsDictionary; // the show/visible contents to end-user, be sure has the same sort/order/sequence realContentsDictionary


/** get the sequential keys of contentsDictionary, against to the table section */
-(NSArray *)sections;
/** get the realValue By indexPath */
-(id) valueForIndexPath: (NSIndexPath*)indexPath;
/** the visible content by indexPath , equals to the cell.textLabel.text */
-(NSString*) contentForIndexPath: (NSIndexPath*)indexPath;

@end
