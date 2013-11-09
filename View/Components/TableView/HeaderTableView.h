#import <UIKit/UIKit.h>

#import "AlignTableView.h"

@class HeaderTableView;

@protocol HeaderTableViewDelegate <TableViewTableProxy>

@optional

@end


@interface HeaderTableView : UIView


@property (nonatomic, assign) id<HeaderTableViewDelegate> delegate;

@property (strong) UIView* headerView;
@property (strong) AlignTableView* tableView;


@property (nonatomic, strong) NSArray* headers;            //here one dimension
@property (nonatomic, strong) NSArray* headersXcoordinates;//here one dimension
@property (nonatomic, strong) NSArray* valuesXcoordinates; //here one dimension


-(void) reloadData ;

@end
