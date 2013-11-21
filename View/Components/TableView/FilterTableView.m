#import "FilterTableView.h"

@implementation FilterTableView {
    NSString* predicateString ;
    NSMutableDictionary* backupContentsDictionary;
}

-(void)setContentsDictionary:(NSMutableDictionary *)contentsDictionary
{
    super.contentsDictionary = contentsDictionary;
    backupContentsDictionary = contentsDictionary;
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
        for (NSString* key in backupContentsDictionary) {
            NSArray* contents = [backupContentsDictionary objectForKey: key];
            NSArray* filteredContents = [contents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:predicateString, filterText]];
            if (filteredContents.count) {
                [searchContentsDictionary setObject:[self sort: filteredContents] forKey:key];
            } else {
                [searchContentsDictionary removeObjectForKey: key];
            }
        }
        super.contentsDictionary = searchContentsDictionary;
        
        
    // Normal Mode
    } else {
        super.contentsDictionary = backupContentsDictionary;
    }
    
    [self reloadData];
}


#pragma mark - Public Methods

-(BOOL) isInFilteringMode
{
    return _filterText != nil && ![_filterText isEqualToString:@""];
}

-(NSIndexPath*) traslateIndexPathInFilterMode: (NSIndexPath*)indexPath
{
    if (![self isInFilteringMode]) return indexPath;
    
    NSString* cellText = [self cellForRowAtIndexPath: indexPath].textLabel.text;
    for (int section = 0 ; section < self.numberOfSections; section++ ){
        NSString* sectionKey = [self.sections objectAtIndex: section];
        NSArray* sectionContents = [backupContentsDictionary objectForKey: sectionKey];
        NSUInteger row = [sectionContents indexOfObject: cellText];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForRow: row inSection:section];
        } else {
            NSLog(@"Error! Check it!");
        }
    }
    return indexPath;
}


#pragma mark - Private Methods

-(NSArray*) sort:(NSArray*)array
{
    NSMutableArray* temp = [NSMutableArray arrayWithArray: array];
    NSArray* result = [temp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare: obj2];
    }];
    return result;
}

@end
