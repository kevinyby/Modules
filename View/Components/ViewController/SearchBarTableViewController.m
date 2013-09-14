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
    
    
    /*
     SearchBar as header and at the top:
     The search bar always stays at the top if the table view is scrolled down and behaves similar to a section header.
     
     Note: For this scrolling behavior it is *essential* that the view controller is a subclass of UIViewController instead of UITableViewController, because UISearchDisplayController adds the dimming view to the searchContentsController's view and because UITableViewController's view is the table view, the dimming view is added to the table view and is only visible when the table view is scrolled to the top. If you can't change the superclass to UIViewController, you'll have to manually set the dimming view's frame by iterating through the table view's view hierarchy when the search begins which is very ugly.
     */
    [self.view addSubview: self.searchBar];
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    
}

#pragma mark - UIScrollViewDelegate Methods

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView) {         // Don't do anything if the search table view get's scrolled
//        if (scrollView.contentOffset.y < -CGRectGetHeight(self.searchBar.bounds)) {
//            self.searchBar.layer.zPosition = 0; // Make sure the search bar is below the section index titles control when scrolling up
//        } else {
//            self.searchBar.layer.zPosition = 1; // Make sure the search bar is above the section headers when scrolling down
//        }
//        
//        CGRect searchBarFrame = self.searchBar.frame;
//        searchBarFrame.origin.y = MAX(scrollView.contentOffset.y, -CGRectGetHeight(searchBarFrame));
//        
//        self.searchBar.frame = searchBarFrame;
//    }
//}

#pragma mark - TableView Delegate and DataSource

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
//    if (section == 2)
//        [headerView setBackgroundColor:[UIColor redColor]];
//    else
//        [headerView setBackgroundColor:[UIColor grayColor]];
//    return headerView;
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (tableView == self.tableView) {
//        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
//    } else {
//        return nil;
//    }
//}

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