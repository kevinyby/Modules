#import "FilterTableView.h"
#import "_Helper.h"

@implementation FilterTableView {
    NSString* predicateString ;
    NSMutableDictionary* contentsDictionaryBackUp;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.filterMode = FilterModeContains;
        self.seletedVisibleIndexPath = nil;
    }
    return self;
}

-(void)setContentsDictionary:(NSMutableDictionary *)contentsDictionary
{
    super.contentsDictionary = contentsDictionary;
    contentsDictionaryBackUp = contentsDictionary;
}

-(void) setFilterMode:(FilterMode)mode
{
    switch (mode) {
        case FilterModeContains:
            predicateString = @"SELF contains[cd] %@";
            break;
            
        case FilterModeBeginWith:
            predicateString = @"self BEGINSWITH[cd] %@";
            break;
            
        default:
            break;
    }
}

-(void)setFilterText:(NSString *)filterText
{
    _filterText = filterText;
    
    // Filter Mode
    if ([self isInFilteringMode]) {
        NSMutableDictionary* searchContentsDictionary = [NSMutableDictionary dictionary];
        for (NSString* key in contentsDictionaryBackUp) {
            NSArray* contents = [contentsDictionaryBackUp objectForKey: key];
            NSArray* filteredContents = [contents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:predicateString, filterText]];
            if (filteredContents.count) {
                [searchContentsDictionary setObject:[ArrayHelper sort: filteredContents] forKey:key];
            } else {
                [searchContentsDictionary removeObjectForKey: key];
            }
        }
        super.contentsDictionary = searchContentsDictionary;
        
        
    // Normal Mode
    } else {
        super.contentsDictionary = contentsDictionaryBackUp;
    }
    
    [super reloadData];
}

#pragma mark - Override UITableView Methods
-(void)reloadData
{
    self.filterText = self.filterText;  // [setFilterText: ] to reload
}

- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.seletedVisibleIndexPath = indexPath;
    if ([self isInFilteringMode])  indexPath = [self traslateFilterModeIndexPath: indexPath];
    if (self.proxy && [self.proxy respondsToSelector:@selector(didSelectIndexPath:on:)]) {
        [self.proxy didSelectIndexPath: indexPath on:self];
    }
}

#pragma mark - Public Methods

-(BOOL) isInFilteringMode
{
    return self.filterText != nil && ![self.filterText isEqualToString:@""] && !self.disable;
}

// get the real index path by view in cell
-(NSIndexPath*) getRealIndexPath:(UIView*)subview 
{
    // get the index path
    NSIndexPath* indexPath = [TableViewHelper getIndexPath: self cellSubView:subview];
    if ([self isInFilteringMode]) indexPath = [self traslateFilterModeIndexPath:indexPath];
    return indexPath;
}

-(NSIndexPath*) traslateFilterModeIndexPath: (NSIndexPath*)indexPath
{
    if (![self isInFilteringMode]) return indexPath;
    
    NSString* cellText = [self cellForRowAtIndexPath: indexPath].textLabel.text;
    for (int section = 0 ; section < self.numberOfSections; section++ ){
        NSString* sectionKey = [self.sections objectAtIndex: section];
        NSArray* sectionContents = [contentsDictionaryBackUp objectForKey: sectionKey];
        NSUInteger row = [sectionContents indexOfObject: cellText];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForRow: row inSection:section];
        }
    }
    
    NSLog(@"Error!!!!!");
    return [NSIndexPath indexPathForRow: -1 inSection:-1];
}

@end
