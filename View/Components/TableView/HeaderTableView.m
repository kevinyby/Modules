#import "HeaderTableView.h"
#import "AlignTableView.h"

// _View.h
#import "FrameTranslater.h"

@implementation HeaderTableView

@synthesize tableView;
@synthesize headerView;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
        [self initializeSubviewsHConstraints];
        [self initializeSubviewsVConstraints];
    }
    return self;
}

-(void)setHeaders:(NSArray *)headers
{
    tableView.headers = headers;
    [AlignTableView setAlignHeaders: tableView headerView:headerView headers:tableView.headers headersXcoordinates:tableView.valuesXcoordinates];
}

-(void) setHeadersXcoordinates:(NSArray *)headersXcoordinates
{
    tableView.headersXcoordinates = headersXcoordinates;
    [AlignTableView setAlignHeaders:tableView headerView:headerView headers:tableView.headers headersXcoordinates:tableView.headersXcoordinates];
}

-(void)setValuesXcoordinates:(NSArray *)valuesXcoordinates
{
    tableView.valuesXcoordinates = valuesXcoordinates;
//    [tableView reloadData];       // need it or not ?
}

#pragma mark - Public Methods

-(void) reloadTableData {
    [tableView reloadData];
}

-(void) removeSubviewConstraints
{
    for (UIView* subview in self.subviews)[subview setTranslatesAutoresizingMaskIntoConstraints: YES];
    [self removeConstraints: self.constraints];
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
    float inset = [FrameTranslater convertCanvasHeight: 0.0f];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[headerView(headerHeight)]-(inset)-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"headerHeight":@(headerHeight),@"inset":@(inset)}
                          views:NSDictionaryOfVariableBindings(headerView,tableView)]];
    
}

@end
