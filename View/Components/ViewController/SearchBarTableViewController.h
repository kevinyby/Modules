#import <UIKit/UIKit.h>

@interface SearchBarTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
}

@property(nonatomic, copy) NSArray *contents;

@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong, readonly) UISearchBar *searchBar;

@end