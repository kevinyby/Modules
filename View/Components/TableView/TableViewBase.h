#import <UIKit/UIKit.h>


@class TableViewBase;

@protocol TableViewBaseProxy <NSObject>


@optional

- (void)didSelectIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

- (void)willShowIndexPath:(NSIndexPath*)indexPath withCell:(UITableViewCell*)cell on:(TableViewBase *)tableViewObj;

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

// this method, you had better not implement it except in special case .
- (UITableViewCell*)cellForIndexPath:(NSIndexPath *)indexPath on:(TableViewBase *)tableViewObj;

@end







@interface TableViewBase : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(assign) id<TableViewBaseProxy> proxy;

@property(nonatomic, assign) BOOL hideSections;

// { @"section_1":@[@"1",@"2",@"3"], @"section_2":@[@"a",@"b",@"c"] };
@property(nonatomic, strong) NSDictionary* contentsDictionary; // the visible contents


/** get the sequential keys of contentsDictionary, against to the table section */
-(NSArray*) getSections ;

@end
