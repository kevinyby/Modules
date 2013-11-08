#import "HeaderTableView.h"
#import "AlignTableView.h"

@implementation HeaderTableView

@synthesize delegate;

@synthesize tableView;
@synthesize headerView;


@synthesize headers;
@synthesize valuesXcoodinates;

- (id)init
{
    self = [super init];
    if (self) {
        headerView = [[UIView alloc] init];
        tableView = [[AlignTableView alloc] init];
        [self addSubview: tableView];
        [self addSubview: headerView];
        [self setSubviewsConstraints];
    }
    return self;
}

- (id)initWithHeaders: (NSArray*)headersObj xCoordinates:(NSArray*)xCoordinates
{
    self = [self init];
    if (self) {
        headers = headersObj;
        valuesXcoodinates = xCoordinates;
    }
    return self;
}

-(void)setHeaders:(NSArray *)headersObj
{
    headers = headersObj;
    tableView.headers = headersObj;
    
    [self refreshHeader];
}

-(void)setValuesXcoodinates:(NSArray *)valuesXcoodinatesObj {
    valuesXcoodinates = valuesXcoodinatesObj;
    tableView.valuesXcoodinates = valuesXcoodinatesObj;
    
    [self refreshHeader];
}

-(void)setDelegate:(id<HeaderTableViewDelegate>)delegateObj {
    delegate = delegateObj;
    tableView.proxy = delegateObj;
}

#pragma mark - Public Methods

-(void) refreshHeader
{
    [AlignTableView setAlignHeaders:headerView headers:headers valuesXcoodinates:valuesXcoodinates];
}

-(void) reloadData {
    [tableView reloadData];
}

#pragma mark - Private Methods

-(void) setSubviewsConstraints
{
    float inset = 0.0f;         // for test
    
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
    
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[headerView(25)]"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(headerView)]];
    
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[headerView]-(inset)-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"inset":@(inset)}
                          views:NSDictionaryOfVariableBindings(headerView,tableView)]];
}

@end
