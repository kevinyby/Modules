#import <UIKit/UIKit.h>

#import "AlignTableView.h"

@interface HeaderTableView : UIView


@property (strong) UIView* headerView;
@property (strong) AlignTableView* tableView;


@property (nonatomic, strong) NSArray* headers;            // one dimension
@property (nonatomic, strong) NSArray* headersXcoodinates; // one dimension


- (id)initWithHeaders: (NSArray*)headersObj xCoordinates:(NSArray*)xCoordinates;

-(void) reloadData ;

-(void) refreshHeader;

@end
