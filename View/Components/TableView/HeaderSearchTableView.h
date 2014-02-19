#import "HeaderTableView.h"

@interface HeaderSearchTableView : HeaderTableView <UISearchBarDelegate>

@property (strong) UISearchBar *searchBar;
//@property (strong) SearchBarView *searchBar;

@property (assign,nonatomic) BOOL hideSearchBar;    // default NO , use it to hide search bar temporary.

@end
