#import "SearchBarTableViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const tableViewCellId = @"tableViewCellId";

@interface SearchBarTableViewController () {
    
}

@property(nonatomic, copy) NSArray *sectionContents;

@property(nonatomic, copy) NSArray *filteredContents;

@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, strong, readwrite) UISearchBar *searchBar;

// UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; 

@end

@implementation SearchBarTableViewController


-(void)setContents:(NSArray *)contents {
    if (_contents) {
        [_contents release];
        _contents = nil;
    }
    _contents = [contents retain];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    int count = [[collation sectionTitles] count];
    NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for (NSString *personName in _contents) {
        NSInteger index = [collation sectionForObject:personName collationStringSelector:@selector(description)];
        [[unsortedSections objectAtIndex:index] addObject:personName];
    }
    
    NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
    for (NSMutableArray *section in unsortedSections) {
        [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    [unsortedSections release];
    
    self.sectionContents = sortedSections;
    [sortedSections release];
}

#pragma mark - Override Methods

-(void)dealloc {
    [_contents release];
    [_sectionContents release];
    [_filteredContents release];
    
    [_tableView release];
    [_searchBar release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView* table = [[UITableView alloc] initWithFrame: self.view.bounds];
    self.tableView = table;
    [table release];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    UISearchBar* bar = [[UISearchBar alloc] init];
    self.searchBar = bar;
    [bar release];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    
    UISearchDisplayController* controller = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.strongSearchDisplayController = controller;
    [controller release];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
    [self.view addSubview: self.searchBar];
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    
}

#pragma mark - TableView Delegate and DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if ([[self.sectionContents objectAtIndex:section] count] > 0) {
            NSString* titleForHead = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
            return titleForHead;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.sectionContents.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [[self.sectionContents objectAtIndex:section] count];
    // in search mode
    } else {
        return self.filteredContents.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellId];
    if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellId] autorelease];  // auto release , no problem ???
    
    if (tableView == self.tableView) {
        cell.textLabel.text = [[self.sectionContents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
        NSArray *personsToSearch = _contents;
        
        self.filteredContents = [personsToSearch filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
        
    // in search mode, when delete the search string
    } else {
        self.filteredContents = _contents;
    }
    
    return YES;
}

@end