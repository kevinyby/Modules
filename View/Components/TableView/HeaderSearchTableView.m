#import "HeaderSearchTableView.h"
#import "AlignTableView.h"
#import "SearchBarView.h"

#import "FrameTranslater.h"

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
    
    searchBar = [[SearchBarView alloc] init];
    searchBar.delegate = self;
    searchBar.textField.placeholder = @"Search";
    [searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview: searchBar];
}

-(void)initializeSubviewsHConstraints
{
    [super initializeSubviewsHConstraints];
    
    if ([self.subviews containsObject: searchBar]) {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"|-0-[searchBar]-0-|"
                              options:NSLayoutFormatAlignAllBaseline
                              metrics:nil
                              views:NSDictionaryOfVariableBindings(searchBar)]];
    }
}

-(void) initializeSubviewsVConstraints
{
    if ([self.subviews containsObject: searchBar]) {
        UIView* headerView = super.headerView;
        UITableView* tableView = super.tableView;
        
        float searchBarHeight =[FrameTranslater convertCanvasHeight: 60.0f];
        float headerHeight = [FrameTranslater convertCanvasHeight: 25.0f];
        float inset = [FrameTranslater convertCanvasHeight: 0.0f];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:|-0-[searchBar(searchBarHeight)][headerView(headerHeight)]-(inset)-[tableView]-0-|"
                              options:NSLayoutFormatDirectionLeadingToTrailing
                              metrics:@{@"searchBarHeight":@(searchBarHeight), @"headerHeight":@(headerHeight), @"inset":@(inset)}
                              views:NSDictionaryOfVariableBindings(searchBar,headerView,tableView)]];
    } else {
        [super initializeSubviewsVConstraints];
    }
    
}


#pragma mark - SearchBarViewDelegate Methods
- (void)searchBarView:(SearchBarView *)searchBar textDidChange:(NSString *)searchText
{
    super.tableView.filterText = searchText;
}
- (void)searchBarViewCancelButtonClicked:(SearchBarView *) searchBar
{
    [self.searchBar.textField resignFirstResponder];
    
    self.searchBar.textField.text = nil;    // clear
    super.tableView.filterText = nil;       // filter
}
- (void)searchBarViewSearchButtonClicked:(SearchBarView *)searchBar
{
    [self.searchBar.textField resignFirstResponder];
}

@end
