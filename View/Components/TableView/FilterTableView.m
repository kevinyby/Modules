#import "FilterTableView.h"
#import "_Helper.h"

@implementation FilterTableView

@synthesize contentsDictionaryBackup;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.filterMode = FilterModeContains;
        self.seletedVisibleIndexPath = nil;
    }
    return self;
}

-(void)setContentsDictionary:(NSMutableDictionary *)contentsDictionary
{
    super.contentsDictionary = contentsDictionary;
    contentsDictionaryBackup = contentsDictionary;
}

-(void)setFilterText:(NSString *)filterText
{
    _filterText = filterText;
    
    // Filter Mode
    if ([self isInFilteringMode]) {
        NSMutableDictionary* searchContentsDictionary = [NSMutableDictionary dictionary];
        
        for (NSString* key in contentsDictionaryBackup) {
            NSArray* contents = [contentsDictionaryBackup objectForKey: key];
            
            NSMutableArray* results = [NSMutableArray array];
            
            for (int i = 0; i < contents.count; i++) {
                id value = [contents objectAtIndex: i];
                NSString* string = nil;
                // string
                if ([value isKindOfClass:[NSString class]]) {
                    string = value;
                // array
                } else if ([value isKindOfClass:[NSArray class]]) {
                    NSArray* array = [contents objectAtIndex:i];
                    string = [array componentsJoinedByString:@" "];
                }
                // is meet
                BOOL isBingo = self.filterMode == FilterModeContains ? [string rangeOfString:filterText options:NSCaseInsensitiveSearch].location != NSNotFound : [string hasPrefix: filterText];
                if (isBingo) [results addObject: value];
            }
            
            if (results.count) {
                [searchContentsDictionary setObject: results forKey:key];
            } else {
                [searchContentsDictionary removeObjectForKey: key];
            }
        }
        super.contentsDictionary = searchContentsDictionary;
        
        
    // Normal Mode
    } else {
        super.contentsDictionary = contentsDictionaryBackup;
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
    
    // super
    [super tableView: tableViewObj didSelectRowAtIndexPath:indexPath];
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
    
    id value = [super contentForIndexPath: indexPath];
    
    for (NSInteger section = 0 ; section < self.numberOfSections; section++ ){
        NSString* sectionKey = [self.sections objectAtIndex: section];
        NSArray* sectionContents = [contentsDictionaryBackup objectForKey: sectionKey];
        NSUInteger row = [sectionContents indexOfObject: value];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForRow: row inSection:section];
        }
    }
    
    NSLog(@"Error!!!!!");
    return [NSIndexPath indexPathForRow: -1 inSection:-1];
}

@end
