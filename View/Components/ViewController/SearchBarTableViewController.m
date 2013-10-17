#import "SearchBarTableViewController.h"

static NSString * const tableViewCellId = @"tableViewCellId";

@interface SearchBarTableViewController () {
    NSMutableArray* _contents;
    NSMutableArray* _sections;
}

@property(nonatomic, copy) NSArray *filteredContents;

// UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; 

@end

@implementation SearchBarTableViewController

@synthesize contentsDictionary;
@synthesize showSectionTitle;

@synthesize tableView;
@synthesize searchBar;
@synthesize filteredContents;

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
    
    UISearchDisplayController* controller = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.strongSearchDisplayController = controller;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
    [self.view addSubview: self.searchBar];
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


#pragma mark - Public Methods

-(NSString*) getSectionTitle: (NSInteger)section {
    return showSectionTitle ? [_sections objectAtIndex: section] : Nil;
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
        return self.filteredContents.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:tableViewCellId];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellId];  // auto release , no problem ???
    
    // in normal mode
    if (tableViewObj == tableView) {
        NSString* sectionKey = [_sections objectAtIndex: indexPath.section];
        NSArray* sectionContents = [contentsDictionary objectForKey: sectionKey];
        int row = indexPath.row ;
        cell.textLabel.text = [sectionContents objectAtIndex: row];
        
    // in search mode
    } else {
        cell.textLabel.text = [self.filteredContents objectAtIndex:indexPath.row];
    }
    
    return cell;
}


#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.filteredContents = nil;
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.filteredContents = nil;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    // when enter character
    if (searchString.length > 0) { 
        NSArray *searchContents = _contents;
        
        self.filteredContents = [searchContents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
        
    // in search mode, when delete the search string
    } else {
        self.filteredContents = _contents;
        [tableView reloadData];
    }
    
    return YES;
}

@end