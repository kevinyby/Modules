#import "SearchBarTableViewController.h"


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define STATUSBAR_ORIENTATION [UIApplication sharedApplication].statusBarOrientation
#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define STATUSBAR_WIDTH [UIApplication sharedApplication].statusBarFrame.size.width
#define STATUSBAR_HIDDEN [UIApplication sharedApplication].statusBarHidden

@interface SearchBarTableViewController () {
    NSMutableArray* _contents;
    NSMutableArray* _sections;
}

@property(nonatomic, copy) NSString* searchedString;
@property(nonatomic, copy) NSArray *searchedContents;

@end

@implementation SearchBarTableViewController

@synthesize contentsDictionary;
@synthesize showSectionTitle;

@synthesize tableView;
@synthesize searchBar;
@synthesize searchDisplayController;

@synthesize searchedString;
@synthesize searchedContents;

#pragma mark - Override Methods

-(id)init {
    self = [super init];
    if (self) {
        showSectionTitle = YES;
        _contents = [[NSMutableArray alloc] init];
        _sections = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) setContentsDictionary:(NSDictionary *)contentsDictionaryObj {
    if (contentsDictionary) {
        contentsDictionary = nil;
    }
    contentsDictionary = contentsDictionaryObj;
    [_contents removeAllObjects];
    [_sections removeAllObjects];
    
    for (NSString* key in contentsDictionary) {
        [_sections addObject: key];
        [_contents addObjectsFromArray: [contentsDictionary objectForKey: key]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[UITableView alloc] initWithFrame: self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    
    // UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
    [self.view addSubview: self.searchBar];
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;       // important !!!
//    [self.navigationController setNavigationBarHidden:NO animated:YES];   // be sure this invoke before [self fixStatusBarFrameOnIOS7]
    [self fixStatusBarFrameOnIOS7];
}


#pragma mark - Public Methods

-(void) setViewFrame: (CGRect)frame {
    self.view.frame = frame;
    self.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.searchBar.frame.size.height);
    self.tableView.frame = self.view.bounds;
    [self fixStatusBarFrameOnIOS7];
}

-(void) setViewBounds: (CGRect)bounds {
    self.view.bounds = bounds;
    self.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.searchBar.frame.size.height);
    self.tableView.frame = self.view.bounds;
    [self fixStatusBarFrameOnIOS7];
}

-(NSString*) getSectionKey: (NSInteger)section {
    return showSectionTitle ? [_sections objectAtIndex: section] : Nil;
}

-(NSArray*) getSectionContents: (NSInteger)section {
    NSString* sectionKey = [_sections objectAtIndex: section];
    return [contentsDictionary objectForKey: sectionKey];
}

-(void) fixStatusBarFrameOnIOS7 {
    BOOL navBarVisible = self.navigationController && !self.navigationController.isNavigationBarHidden;
    CGFloat height = navBarVisible ? 0 : UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION) ? STATUSBAR_HEIGHT : STATUSBAR_WIDTH;
    if (IOS_VERSION >= 7.0 && ! STATUSBAR_HIDDEN) {
        searchBar.frame = CGRectMake(0, height, searchBar.bounds.size.width, searchBar.bounds.size.height);
    }
}

#pragma mark - TableView Delegate and DataSource

- (NSString *)tableView:(UITableView *)tableViewObj titleForHeaderInSection:(NSInteger)section {
    return showSectionTitle ? [_sections objectAtIndex: section] : nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewObj {
    return showSectionTitle ? _sections.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableViewObj numberOfRowsInSection:(NSInteger)section {
    
    // in normal mode
    if (tableViewObj == tableView) {
        NSString* sectionKey = [_sections objectAtIndex: section];
        NSArray* sectionContents = [contentsDictionary objectForKey: sectionKey];
        return sectionContents.count;
        
    // in search mode
    } else {
        self.searchedContents = [_contents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchedString]];
        
        return self.searchedContents.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const tableViewCellId = @"tableViewCellId";
    
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:tableViewCellId];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellId];  // auto release , no problem ???
    
    // in normal mode
    if (tableViewObj == tableView) {
        NSArray* sectionContents = [self getSectionContents: indexPath.section];
        cell.textLabel.text = [sectionContents objectAtIndex: indexPath.row];
        
    // in search mode
    } else {
        cell.textLabel.text = [self.searchedContents objectAtIndex:indexPath.row];
    }
    
    return cell;
}


#pragma mark - UISearchDisplayDelegate

static bool flag = NO;
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searchedString = nil;
    self.searchedContents = nil;

    // fix Pair A  : isNavigationBarHidden = YES
    if (IOS_VERSION >= 7.0 && ! STATUSBAR_HIDDEN) {
        BOOL navBarVisible = self.navigationController && !self.navigationController.isNavigationBarHidden;
        flag = navBarVisible;
        
        CGFloat height = UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION) ? STATUSBAR_HEIGHT : STATUSBAR_WIDTH;
        if (navBarVisible) searchBar.frame = CGRectMake(0, height, searchBar.bounds.size.width, searchBar.bounds.size.height);
    }
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchedString = nil;
    self.searchedContents = nil;
    
    // fix Pair B : isNavigationBarHidden = NO
    if (IOS_VERSION >= 7.0 && ! STATUSBAR_HIDDEN) {
        BOOL navBarVisible = self.navigationController && !self.navigationController.isNavigationBarHidden;
        if (flag != navBarVisible) searchBar.frame = CGRectMake(0, 0, searchBar.bounds.size.width, searchBar.bounds.size.height);
    }
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // when enter character
    if (searchString.length > 0) {
        self.searchedString = searchString;
        
    // in search mode, when delete the search string
    } else {
        self.searchedString = nil;
        self.searchedContents = nil;
    }
    
    return YES;
}

@end