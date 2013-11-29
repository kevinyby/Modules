#import "TableViewBase.h"

#import "_View.h"
#import "_Helper.h"

static NSString* const RaiseTableViewCellId = @"RaiseTableViewCellId";


@implementation TableViewBase
{
    NSArray* _sections;
}

@synthesize proxy;

@synthesize scrollProxy;

- (id)init
{
    self = [super init];
    if (self) {
        self.hideSections = YES;
        self.dataSource = self;
        self.delegate = self;
        //http://stackoverflow.com/questions/14520185/ios-uitableview-displaying-empty-cells-at-the-end
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) [self setSeparatorInset:UIEdgeInsetsZero];     // ios 7
    }
    return self;
}

-(void)setContentsDictionary:(NSMutableDictionary *)contentsDictionary
{
    _contentsDictionary = contentsDictionary;
    _sections = [DictionaryHelper getSortedKeys: _contentsDictionary];
}

-(NSArray *)sections
{
    return _sections;
}

-(id) realContentForIndexPath: (NSIndexPath*)indexPath
{
    NSString* sectionTitle = [self.sections objectAtIndex: indexPath.section] ;
    NSString* key = self.keysMap ? [self.keysMap objectForKey: sectionTitle] : sectionTitle;
    return [[self.realContentsDictionary objectForKey: key] objectAtIndex: indexPath.row];
}

-(NSString*) contentForIndexPath: (NSIndexPath*)indexPath
{
    return [[self.contentsDictionary objectForKey: [self.sections objectAtIndex: indexPath.section]] objectAtIndex: indexPath.row];
}



#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableViewObj titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectSafeAtIndex: section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewObj {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableViewObj numberOfRowsInSection:(NSInteger)section {
    NSArray* sectionContents = [self.contentsDictionary objectForKey: [self.sections objectSafeAtIndex: section]];
    return sectionContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:RaiseTableViewCellId];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RaiseTableViewCellId];

    NSString* cellText = [self contentForIndexPath: indexPath];     // == cell.textLabel.text , the key point!
    
    cell.textLabel.font = [UIFont systemFontOfSize: [FrameTranslater convertFontSize: 20]];
    cell.textLabel.text = cellText;
    
    if (proxy && [proxy respondsToSelector:@selector(cellForIndexPath:on:)]) {
        cell = [proxy cellForIndexPath: indexPath on:self];
    }
    
    return cell;
}





#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.hideSections ? 0 :  25;
}

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
