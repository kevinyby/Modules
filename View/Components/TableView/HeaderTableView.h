
@class AlignTableView;

@interface HeaderTableView : UIView

@property (strong) UIView* headerView;
@property (strong) AlignTableView* tableView;


@property (nonatomic, strong) NSArray* headers;            //here one dimension
@property (nonatomic, strong) NSArray* headersXcoordinates;//here one dimension
@property (nonatomic, strong) NSArray* valuesXcoordinates; //here one dimension


#pragma mark - Public Methods
-(void) reloadTableData ;           // reload table view data
-(void) removeSubviewConstraints;   // remove the constraints


#pragma mark - Subclass Override Methods
-(void) initializeSubviews;
-(void) initializeSubviewsHConstraints;
-(void) initializeSubviewsVConstraints;

@end
