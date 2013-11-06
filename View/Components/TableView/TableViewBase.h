#import <UIKit/UIKit.h>


@class TableViewBase;

@protocol TableViewTableProxy <NSObject>


@optional

- (void)didSelectIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

- (void)willShowIndexPath:(NSIndexPath*)indexPath withCell:(UITableViewCell*)cell on:(TableViewBase *)tableViewObj;

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

// this method, you had better not implement it except in special case .
- (UITableViewCell*)cellForIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

@end


@protocol TableViewScrollProxy <NSObject>

@optional

- (void)didScroll:(TableViewBase *)tableViewObj;

- (void)didEndDragging:(BOOL)willDecelerate on:(TableViewBase *)tableViewObj;

@end







@interface TableViewBase : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(assign) id<TableViewTableProxy> proxy;

@property(assign) id<TableViewScrollProxy> scrollProxy;

@property(nonatomic, assign) BOOL hideSections;

// { @"section_1":@[@"1",@"2",@"3"], @"section_2":@[@"a",@"b",@"c"] };
@property(nonatomic, strong) NSDictionary* contentsDictionary; // the visible contents


/** get the sequential keys of contentsDictionary, against to the table section */
-(NSArray*) getSections ;

@end
