#import "HeaderTableView.h"
#import "AlignTableView.h"

// _View.h
#import "FrameTranslater.h"

@implementation HeaderTableView

@synthesize tableView;
@synthesize headerView;
@synthesize headerDelegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
        [self restoreConstraints];
    }
    return self;
}

-(void)setHeaders:(NSArray *)headers
{
    tableView.headers = headers;
    [AlignTableView setAlignHeaders: tableView headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates headersYcoordinates:tableView.headersYcoordinates];
}

-(void) setHeadersXcoordinates:(NSArray *)headersXcoordinates
{
    tableView.headersXcoordinates = headersXcoordinates;
    [AlignTableView setAlignHeaders: tableView headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates headersYcoordinates:tableView.headersYcoordinates];
}

-(void) setHeadersYcoordinates:(NSArray *)headersYcoordinates
{
    tableView.headersYcoordinates = headersYcoordinates;
    [AlignTableView setAlignHeaders: tableView headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates headersYcoordinates:tableView.headersYcoordinates];
}

-(void)setValuesXcoordinates:(NSArray *)valuesXcoordinates
{
    tableView.valuesXcoordinates = valuesXcoordinates;
}

-(void) setValuesYcoordinates:(NSArray *)valuesYcoordinates
{
    tableView.valuesYcoordinates = valuesYcoordinates;
}

-(void)setHeaderDelegate:(id<HeaderTableViewDeletage>)headerDelegateObj
{
    headerDelegate = headerDelegateObj;
    // reset it
    [self restoreConstraints];
    // refresh
    [self setNeedsLayout];
}

#pragma mark - Private Methods
-(void) restoreConstraints
{
    [self removeConstraints: self.constraints];
    [self initializeSubviewsHConstraints];
    [self initializeSubviewsVConstraints];
}


#pragma mark - Public Methods
-(void) reloadTableData {
    [tableView reloadData];
}

#pragma mark - Subclass Override Methods

-(void) initializeSubviews
{
    headerView = [[UIView alloc] init];
    tableView = [[AlignTableView alloc] init];
    
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    headerView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    
    [self addSubview: tableView];
    [self addSubview: headerView];
}

-(void) initializeSubviewsHConstraints
{
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|-0-[headerView]-0-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(headerView)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|-0-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(tableView)]];
}

-(void) initializeSubviewsVConstraints
{
    float headerHeight = [FrameTranslater convertCanvasHeight: 25.0f];
    if (headerDelegate && [headerDelegate respondsToSelector:@selector(headerTableViewHeaderHeight:)]) {
        headerHeight = [headerDelegate headerTableViewHeaderHeight:self];
    }
    float gap = [FrameTranslater convertCanvasHeight: 0.0f];
    if (headerDelegate && [headerDelegate respondsToSelector:@selector(headerTableViewGap:)]) {
        gap = [headerDelegate headerTableViewGap: self];
    }
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[headerView(headerHeight)]-(gap)-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"headerHeight":@(headerHeight),@"gap":@(gap)}
                          views:NSDictionaryOfVariableBindings(headerView,tableView)]];
    
}

@end
