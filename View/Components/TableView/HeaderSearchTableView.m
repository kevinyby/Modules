#import "HeaderSearchTableView.h"
#import "AlignTableView.h"

//#import "_View.h"
//#import "_Frame.h"
#import "FrameTranslater.h"

@interface HeaderSearchTableView () <UISearchBarDelegate>

@property (strong) UISearchBar *searchBar;

@end

@implementation HeaderSearchTableView

@synthesize searchBar;

-(void)setHideSearchBar:(BOOL)hideSearchBar
{
    _hideSearchBar = hideSearchBar;
    
    if (hideSearchBar) {
        searchBar.hidden = YES;
        [searchBar removeFromSuperview];
        [self removeConstraints: self.constraints];
        [super initializeSubviewsHConstraints];
        [super initializeSubviewsVConstraints];
    } else {
        searchBar.hidden = NO;
        [self addSubview: searchBar];
        [self removeConstraints: self.constraints];
        [self initializeSubviewsHConstraints];
        [self initializeSubviewsVConstraints];
    }
}


-(void) initializeSubviews
{
    [super initializeSubviews];
    
    searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search";
    searchBar.showsCancelButton = YES;
    [self addSubview: searchBar];
}

-(void)initializeSubviewsHConstraints
{
    [super initializeSubviewsHConstraints];
    
    [searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|-0-[searchBar]-0-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(searchBar)]];
}

-(void) initializeSubviewsVConstraints
{
    UIView* headerView = super.headerView;
    UITableView* tableView = super.tableView;
    
    float headerHeight = [FrameTranslater convertCanvasHeight: 25.0f];
    float inset = [FrameTranslater convertCanvasHeight: 0.0f];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[searchBar][headerView(headerHeight)]-(inset)-[tableView]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"headerHeight":@(headerHeight),@"inset":@(inset)}
                          views:NSDictionaryOfVariableBindings(searchBar,headerView,tableView)]];
    
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    super.tableView.filterText = searchText;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.searchBar resignFirstResponder];
}

@end
