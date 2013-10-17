#import <UIKit/UIKit.h>

@interface SearchBarTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
}

// [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects: @"LeaveOrder", @"OutOrder", nil] forKey:@"HumanResource"];
@property(nonatomic, strong) NSDictionary* contentsDictionary;
@property(nonatomic, assign) BOOL showSectionTitle;

@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong, readonly) UISearchBar *searchBar;


-(void) fixStatusBarFrameOnIOS7 ;

-(void) setViewFrame: (CGRect)frame ;
-(void) setViewBounds: (CGRect)bounds ;

-(NSString*) getSectionTitle: (NSInteger)section ;

@end