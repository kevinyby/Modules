#import "TableViewBase.h"

//#import "_View.h"
#import "NSArray+Additions.h"

//#import "_Frame.h"
#import "FrameTranslater.h"

//#import "_Helper.h"
#import "DictionaryHelper.h"



@interface TableViewBase()  // Class Extension
{
    // _____________________ ActionBlock Category
    
    // UITableViewDataSource
    NSInteger(^_tableViewBaseNumberOfSectionsAction)(TableViewBase* tableViewObj);
    NSInteger(^_tableViewBaseNumberOfRowsInSectionAction)(TableViewBase* tableViewObj, NSInteger section);
    UITableViewCell* (^_tableViewBaseCellForIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath,UITableViewCell* oldCell);
    BOOL (^_tableViewBaseCanEditIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
    void (^_tableViewBaseCommitEditStyleAction)(TableViewBase* tableViewObj, UITableViewCellEditingStyle editStyle, NSIndexPath* indexPath);
    
    BOOL (^_tableViewBaseShouldDeleteContentsAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
    void (^_tableViewBaseDidDeleteContentsAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
    
    // UITableViewDelegate
    void (^_tableViewBaseWillShowCellAction)(TableViewBase* tableViewObj,UITableViewCell* cell, NSIndexPath* indexPath);
    void (^_tableViewBaseDidSelectAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
    CGFloat(^_tableViewBaseHeightForSectionAction)(TableViewBase* tableViewObj,NSInteger section);
    CGFloat(^_tableViewBaseHeightForIndexPathAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
    NSString*(^_tableViewBaseTitleForDeleteButtonAction)(TableViewBase* tableViewObj, NSIndexPath* indexPath);
}

@end



static NSString* const tableViewBaseCellId = @"tableViewBaseCellId";

@implementation TableViewBase
{
    NSArray* _sections;
}

@synthesize proxy;

@synthesize scrollProxy;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultVariables];
    }
    return self;
}

-(void) setDefaultVariables
{
    self.hideSections = YES;
    self.dataSource = self;
    self.delegate = self;
    
    // uitableview displaying empty cells at the end
    // if you want the empty cells line back , just set the footerView back to nil !!
    //http://stackoverflow.com/questions/14520185/ios-uitableview-displaying-empty-cells-at-the-end
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // UITableViewCell in ios7 now has gaps on left and right
    // http://stackoverflow.com/questions/18982347/uitableviewcell-in-ios7-now-has-gaps-on-left-and-right/19059028#19059028
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) [self setSeparatorInset:UIEdgeInsetsZero];     // ios 7
}

-(NSString *)cellReuseIdentifier
{
    return tableViewBaseCellId;
}

-(void)setContentsDictionary:(NSMutableDictionary *)contentsDictionary
{
    _contentsDictionary = contentsDictionary;
    _sections = [DictionaryHelper getSortedKeys: contentsDictionary];
}

-(NSArray *)sections
{
    return _sections;
}

-(id) realContentForIndexPath: (NSIndexPath*)indexPath
{
    return [[self realContentsForSection: indexPath.section] objectAtIndex: indexPath.row];
}

-(NSString*) contentForIndexPath: (NSIndexPath*)indexPath
{
    return [[self contentsForSection: indexPath.section] objectAtIndex: indexPath.row];
}

-(NSMutableArray*) realContentsForSection: (NSUInteger)section
{
    NSString* sectionTitle = [self.sections objectAtIndex: section] ;
    NSString* key = self.keysMap ? [self.keysMap objectForKey: sectionTitle] : sectionTitle;
    return [self.realContentsDictionary objectForKey: key];
}

-(NSMutableArray*) contentsForSection: (NSUInteger)section
{
    return [self.contentsDictionary objectForKey: [self.sections objectAtIndex: section]];
}

#pragma mark - Util Methods
-(void) deleteIndexPath: (NSIndexPath*)indexPath
{
    // A . delete the contents dictionary row data
    NSString* sectionTitle = [self.sections safeObjectAtIndex: indexPath.section];
    NSMutableArray* sectionContents = [self.contentsDictionary objectForKey: sectionTitle];
    [sectionContents removeObjectAtIndex: indexPath.row];
    
    // B . delete the real contents dictionary row data
    NSString* key = self.keysMap ? [self.keysMap objectForKey: sectionTitle] : sectionTitle;
    NSMutableArray* realSectionContents = [self.realContentsDictionary objectForKey: key];
    [realSectionContents removeObjectAtIndex: indexPath.row];
    
    
    // C . apply the animation
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewObj {
    NSInteger count = self.sections.count;
    // proxy
    if (self.tableViewBaseNumberOfSectionsAction) {
        count = self.tableViewBaseNumberOfSectionsAction(self);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBaseNumberOfSections:)]) {
        count = [proxy tableViewBaseNumberOfSections: self];
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableViewObj numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self contentsForSection: section].count;
    // proxy
    if (self.tableViewBaseNumberOfRowsInSectionAction) {
        count = self.tableViewBaseNumberOfRowsInSectionAction(self, section);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBaseNumberOfRows:inSection:)]){
        count = [proxy tableViewBaseNumberOfRows:self inSection:section];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:tableViewBaseCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewBaseCellId];
        cell.textLabel.font = [UIFont systemFontOfSize: [FrameTranslater convertFontSize: 20]];
    }
    
    // proxy
    if (self.tableViewBaseCellForIndexPathAction) {
        cell = self.tableViewBaseCellForIndexPathAction(self, indexPath, cell);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:cellForIndexPath:oldCell:)]) {
        cell = [proxy tableViewBase:self cellForIndexPath:indexPath oldCell:cell];
    }
    
    NSString* cellText = [self contentForIndexPath: indexPath];  // == cell.textLabel.text, for AlignTableView and FilterTableView are important!!!
    cell.textLabel.text = cellText;     // set font first then set text
   
//    cell.layer.borderColor = [[UIColor grayColor] CGColor];
//    cell.layer.borderWidth = 2.0f;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableViewObj titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex: section];
}


// Edit Pair A .
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // proxy
    if (self.tableViewBaseCanEditIndexPathAction) {
        return self.tableViewBaseCanEditIndexPathAction(self, indexPath);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:canEditIndexPath:)]) {
        return [proxy tableViewBase:self canEditIndexPath: indexPath];
    }
    return NO;
}
// Edit Pair B .
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // proxy
    if (self.tableViewBaseCommitEditStyleAction) {
        self.tableViewBaseCommitEditStyleAction(self, editingStyle, indexPath);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:commitEditStyle:indexPath:)]) {
        [proxy tableViewBase:self commitEditStyle:editingStyle indexPath:indexPath];
    }
    
    // delete and its animation
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // proxy should delete
        if (self.tableViewBaseShouldDeleteContentsAction) {
            if (! self.tableViewBaseShouldDeleteContentsAction(self, indexPath)) return;
        }
        else
        if (proxy && [proxy respondsToSelector:@selector(tableViewBase:shouldDeleteContentsAtIndexPath:)]) {
            if(! [proxy tableViewBase:self shouldDeleteContentsAtIndexPath: indexPath]) return;
        }
        
        [self deleteIndexPath: indexPath];
        
        // proxy delete
        if (self.tableViewBaseDidDeleteContentsAction) {
            self.tableViewBaseDidDeleteContentsAction(self, indexPath);
        }
        else
        if (proxy && [proxy respondsToSelector:@selector(tableViewBase:didDeleteContentsAtIndexPath:)]) {
            [proxy tableViewBase:self didDeleteContentsAtIndexPath:indexPath];
        }
        
    }
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableViewObj willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // proxy
    if (self.tableViewBaseWillShowCellAction) {
        self.tableViewBaseWillShowCellAction(self, cell, indexPath);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:willShowCell:indexPath:)]) {
        [proxy tableViewBase:self willShowCell:cell indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // proxy
    if (self.tableViewBaseDidSelectAction) {
        self.tableViewBaseDidSelectAction(self,indexPath);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:didSelectIndexPath:)]) {
        [proxy tableViewBase: self didSelectIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.hideSections) return 0;
    
    CGFloat height = [FrameTranslater convertCanvasHeight: 25];
    
    // proxy
    if (self.tableViewBaseHeightForSectionAction) {
        height = self.tableViewBaseHeightForSectionAction(self, section);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:heightForSection:)]) {
        height = [proxy tableViewBase:self heightForSection:section];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [FrameTranslater convertCanvasHeight: 50];
    
    // proxy
    if (self.tableViewBaseHeightForIndexPathAction) {
        height = self.tableViewBaseHeightForIndexPathAction(self, indexPath);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:heightForIndexPath:)]) {
        height = [proxy tableViewBase: self heightForIndexPath:indexPath];
    }
    return height;
}



// Edit Pair Extendions :

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* deleteTitle = @"Delete";
    
    // proxy
    if (self.tableViewBaseTitleForDeleteButtonAction) {
        deleteTitle = self.tableViewBaseTitleForDeleteButtonAction(self, indexPath);
    }
    else
    if (proxy && [proxy respondsToSelector:@selector(tableViewBase:titleForDeleteButtonAtIndexPath:)]) {
        deleteTitle = [proxy tableViewBase: self titleForDeleteButtonAtIndexPath:indexPath];
    }
    
    return deleteTitle;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollProxy && [scrollProxy respondsToSelector:@selector(tableViewBaseDidScroll:)]) {
        [scrollProxy tableViewBaseDidScroll: self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollProxy && [scrollProxy respondsToSelector:@selector(tableViewBase:didEndDragging:)]) {
        [scrollProxy tableViewBase: self didEndDragging:decelerate];
    }
}

@end










//_______________________________________________________________________________________________________________


@implementation TableViewBase (ActionBlock)

//@dynamic tableViewBaseDidSelectAction;        // just tell the complier , u will implementation somewhere , do not show the warning .


// UITableViewDataSource


//_______________________ tableViewBaseNumberOfSectionsAction

-(NSInteger (^)(TableViewBase *))tableViewBaseNumberOfSectionsAction
{
    return _tableViewBaseNumberOfSectionsAction;
}

-(void)setTableViewBaseNumberOfSectionsAction:(NSInteger (^)(TableViewBase *))tableViewBaseNumberOfSectionsAction
{
    _tableViewBaseNumberOfSectionsAction = tableViewBaseNumberOfSectionsAction;
}


//_______________________ tableViewBaseNumberOfRowsInSectionAction

-(NSInteger (^)(TableViewBase *, NSInteger))tableViewBaseNumberOfRowsInSectionAction
{
    return _tableViewBaseNumberOfRowsInSectionAction;
}

-(void)setTableViewBaseNumberOfRowsInSectionAction:(NSInteger (^)(TableViewBase *, NSInteger))tableViewBaseNumberOfRowsInSectionAction
{
    _tableViewBaseNumberOfRowsInSectionAction = tableViewBaseNumberOfRowsInSectionAction ;
}

//_______________________ tableViewBaseCellForIndexPathAction

-(UITableViewCell *(^)(TableViewBase *, NSIndexPath *, UITableViewCell *))tableViewBaseCellForIndexPathAction
{
    return _tableViewBaseCellForIndexPathAction;
}

-(void)setTableViewBaseCellForIndexPathAction:(UITableViewCell *(^)(TableViewBase *, NSIndexPath *, UITableViewCell *))tableViewBaseCellForIndexPathAction
{
    _tableViewBaseCellForIndexPathAction = tableViewBaseCellForIndexPathAction;
}


//_______________________ tableViewBaseCanEditIndexPathAction

-(BOOL (^)(TableViewBase *, NSIndexPath *))tableViewBaseCanEditIndexPathAction
{
    return _tableViewBaseCanEditIndexPathAction;
}

-(void)setTableViewBaseCanEditIndexPathAction:(BOOL (^)(TableViewBase *, NSIndexPath *))tableViewBaseCanEditIndexPathAction
{
    _tableViewBaseCanEditIndexPathAction = tableViewBaseCanEditIndexPathAction;
}

//_______________________ tableViewBaseCommitEditStyleAction

-(void (^)(TableViewBase *, UITableViewCellEditingStyle, NSIndexPath *))tableViewBaseCommitEditStyleAction
{
    return _tableViewBaseCommitEditStyleAction;
}

-(void)setTableViewBaseCommitEditStyleAction:(void (^)(TableViewBase *, UITableViewCellEditingStyle, NSIndexPath *))tableViewBaseCommitEditStyleAction
{
    _tableViewBaseCommitEditStyleAction = tableViewBaseCommitEditStyleAction;
}

//______________________ tableViewBaseShouldDeleteContentsAction

-(BOOL (^)(TableViewBase *, NSIndexPath *))tableViewBaseShouldDeleteContentsAction
{
    return _tableViewBaseShouldDeleteContentsAction;
}

-(void)setTableViewBaseShouldDeleteContentsAction:(BOOL (^)(TableViewBase *, NSIndexPath *))tableViewBaseShouldDeleteContentsAction
{
    _tableViewBaseShouldDeleteContentsAction = tableViewBaseShouldDeleteContentsAction;
}

//______________________ tableViewBaseDidDeleteContentsAction

-(void (^)(TableViewBase *, NSIndexPath *))tableViewBaseDidDeleteContentsAction
{
    return _tableViewBaseDidDeleteContentsAction;
}

-(void)setTableViewBaseDidDeleteContentsAction:(void (^)(TableViewBase *, NSIndexPath *))tableViewBaseDidDeleteContentsAction
{
    _tableViewBaseDidDeleteContentsAction = tableViewBaseDidDeleteContentsAction;
}




// UITableViewDelegate

//_______________________ tableViewBaseWillShowCellAction

-(void (^)(TableViewBase *, UITableViewCell *, NSIndexPath *))tableViewBaseWillShowCellAction
{
    return _tableViewBaseWillShowCellAction;
}
-(void)setTableViewBaseWillShowCellAction:(void (^)(TableViewBase *, UITableViewCell *, NSIndexPath *))tableViewBaseWillShowCellAction
{
    _tableViewBaseWillShowCellAction = tableViewBaseWillShowCellAction;
}

//_______________________ tableViewBaseDidSelectAction

-(void (^)(TableViewBase *, NSIndexPath *))tableViewBaseDidSelectAction
{
    return _tableViewBaseDidSelectAction;
}
-(void)setTableViewBaseDidSelectAction:(void (^)(TableViewBase *, NSIndexPath *))tableViewBaseDidSelectAction
{
    _tableViewBaseDidSelectAction = tableViewBaseDidSelectAction;
}

//_______________________ tableViewBaseHeightForSectionAction

-(CGFloat (^)(TableViewBase *, NSInteger))tableViewBaseHeightForSectionAction
{
    return _tableViewBaseHeightForSectionAction;
}

-(void)setTableViewBaseHeightForSectionAction:(CGFloat (^)(TableViewBase *, NSInteger))tableViewBaseHeightForSectionAction
{
    _tableViewBaseHeightForSectionAction = tableViewBaseHeightForSectionAction;
}

//_______________________ tableViewBaseHeightForIndexPathAction

-(CGFloat (^)(TableViewBase *, NSIndexPath *))tableViewBaseHeightForIndexPathAction
{
    return _tableViewBaseHeightForIndexPathAction;
}

-(void)setTableViewBaseHeightForIndexPathAction:(CGFloat (^)(TableViewBase *, NSIndexPath *))tableViewBaseHeightForIndexPathAction
{
    _tableViewBaseHeightForIndexPathAction = tableViewBaseHeightForIndexPathAction;
}


//_______________________ tableViewBaseTitleForDeleteButtonAction

-(NSString *(^)(TableViewBase *, NSIndexPath *))tableViewBaseTitleForDeleteButtonAction
{
    return _tableViewBaseTitleForDeleteButtonAction;
}

-(void)setTableViewBaseTitleForDeleteButtonAction:(NSString *(^)(TableViewBase *, NSIndexPath *))tableViewBaseTitleForDeleteButtonAction
{
    _tableViewBaseTitleForDeleteButtonAction = tableViewBaseTitleForDeleteButtonAction;
}

@end

