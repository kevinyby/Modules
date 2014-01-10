#import <UIKit/UIKit.h>

#import "AlignTableView.h"

@class HeaderTableView;

@protocol HeaderTableViewDelegate <TableViewBaseTableProxy>

@optional

@end


@interface HeaderTableView : UIView


@property (nonatomic, assign) id<HeaderTableViewDelegate> delegate;

@property (strong) UIView* headerView;
@property (strong) AlignTableView* tableView;


@property (nonatomic, strong) NSArray* headers;            //here one dimension
@property (nonatomic, strong) NSArray* headersXcoordinates;//here one dimension
@property (nonatomic, strong) NSArray* valuesXcoordinates; //here one dimension


#pragma mark - Public Methods
-(void) reloadData ;


#pragma mark - Subclass Override Methods
-(void) initializeSubviews;
-(void) initializeSubviewsHConstraints;
-(void) initializeSubviewsVConstraints;

@end
