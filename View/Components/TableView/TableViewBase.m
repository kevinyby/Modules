#import "TableViewBase.h"
#import "FrameTranslater.h"

static NSString* const RaiseTableViewCellId = @"RaiseTableViewCellId";


@interface TableViewBase() {
     NSMutableArray* _sections;
}

@end

@implementation TableViewBase

@synthesize proxy;

@synthesize scrollProxy;

@synthesize hideSections;

@synthesize contentsDictionary;

- (id)init
{
    self = [super init];
    if (self) {
        self.hideSections = YES;
        self.dataSource = self;
        self.delegate = self;
        _sections = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) setContentsDictionary:(NSMutableDictionary *)contentsDictionaryObj
{
    if (contentsDictionary) {
        contentsDictionary = nil;
    }
    contentsDictionary = contentsDictionaryObj;
    [_sections removeAllObjects];
    
    for (NSString* key in contentsDictionary) {
        [_sections addObject: key];
    }
}

-(NSArray*) getSections
{
    return _sections;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableViewObj titleForHeaderInSection:(NSInteger)section {
    int sectionsHighestCount = _sections.count - 1;
    return hideSections || sectionsHighestCount < (int)section ? nil : [_sections objectAtIndex: section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewObj {
    return hideSections ? 1 : _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableViewObj numberOfRowsInSection:(NSInteger)section {
    int sectionsHighestCount = _sections.count - 1;
    NSString* sectionKey = sectionsHighestCount < (int)section ? nil : [_sections objectAtIndex: section];
    NSArray* sectionContents = [contentsDictionary objectForKey: sectionKey];
    int count = sectionContents.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:RaiseTableViewCellId];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RaiseTableViewCellId];
    int row = indexPath.row;
    int section = indexPath.section ;
    int sectionsHighestCount = _sections.count - 1;
    NSString* sectionKey = sectionsHighestCount < section ? nil : [_sections objectAtIndex: section];
    NSArray* sectionContents = [contentsDictionary objectForKey: sectionKey];
    cell.textLabel.text = [sectionContents objectAtIndex: row];
    
    if (proxy && [proxy respondsToSelector:@selector(cellForIndexPath:on:)]) {
        cell = [proxy cellForIndexPath: indexPath on:self];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableViewObj willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // tableViewObj == self
    if (proxy && [proxy respondsToSelector:@selector(willShowIndexPath:withCell:on:)]) {
        [proxy willShowIndexPath: indexPath withCell:cell on:self];
    }
}

- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (proxy && [proxy respondsToSelector:@selector(didSelectIndexPath:on:)]) {
        [proxy didSelectIndexPath: indexPath on:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (proxy && [proxy respondsToSelector:@selector(heightAtIndexPath:on:)]) {
        return [proxy heightAtIndexPath: indexPath on:self];
    }
    
    CGRect canvas = CGRectMake(0, 0, 0, 50);
    CGRect frame = [FrameTranslater getFrame: canvas];
    CGFloat defaultHeight = frame.size.height;
    return defaultHeight;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollProxy && [scrollProxy respondsToSelector:@selector(didScroll:)]) {
        [scrollProxy didScroll: self];
    }
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollProxy && [scrollProxy respondsToSelector:@selector(didEndDragging:on:)]) {
        [scrollProxy didEndDragging: decelerate on:self];
    }
}

@end
