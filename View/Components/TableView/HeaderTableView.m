#import "HeaderTableView.h"

// _View.h
#import "FrameTranslater.h"

@implementation HeaderTableView

@synthesize delegate;

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

-(void)setDelegate:(id<HeaderTableViewDelegate>)delegateObj {
    delegate = delegateObj;
    tableView.proxy = delegateObj;
}

#pragma mark - Public Methods

-(void) reloadData {
    [tableView reloadData];
}

#pragma mark - Subclass Override Methods

-(void) initializeSubviews
{
    headerView = [[UIView alloc] init];
    tableView = [[AlignTableView alloc] init];
    [self addSubview: tableView];
    [self addSubview: headerView];
    
    headerView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
}

-(void) initializeSubviewsHConstraints
{
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
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
