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

@property(nonatomic, assign) BOOL hideSections;

// { @"section_1":@[[@"1",@"2",@"3"],[@"1",@"2",@"3"]], @"section_2":@[[@"1",@"2",@"3"],[@"1",@"2",@"3"]] };
@property(nonatomic, strong) NSMutableDictionary* contentsDictionary; // the visible contents


/** get the sequential keys of contentsDictionary, against to the table section */
@property (nonatomic, strong) NSArray* sections;

@end
