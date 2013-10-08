#import <UIKit/UIKit.h>

@interface SearchBarTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
}

// [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects: @"LeaveOrder", @"OutOrder", nil] forKey:@"HumanResource"];
@property(nonatomic, retain) NSDictionary* contentsDictionary;
@property(nonatomic, assign) BOOL showSectionTitle;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UISearchBar *searchBar;


-(NSString*) getSectionTitle: (NSInteger)section ;

@end