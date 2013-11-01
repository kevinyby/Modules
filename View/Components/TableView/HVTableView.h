//

/* ===========================================================================
 
 NOTES:	HVTableView addresses two concerns. The first is the ability to have
 a table view that only partially fills the screen. Normally one would use
 UITableViewController but that requires table views that fill the whole
 screen. HVTableView addresses this problem by acting as the controller
 for the embedded table view, and exposing table view functionality
 with it's own delegate methods.
 
 The second concern addressed by HVTableView is horizontal table views.
 Table views were initially designed to be vertical only. HVTableView
 solves this problem by rotating the table view, and provides the same
 interface as creating a vertical HVTableView.
 
 Now you can create simple partial screen table views, either vertically
 or horizontally, with the same interface!
 
 KNOWN LIMITATIONS:
 
 This implementation currently only supports one section. The view relies
 on three reserved view tags, 800 - 802.
 
 A horizontal HVTableView will correctly auto-resize it's overall length only.
 A horizontal HVTableView will NOT necessarily correctly auto-resize it's height.
 */

#import <UIKit/UIKit.h>

typedef enum {
	HVTableViewOrientationVertical,
	HVTableViewOrientationHorizontal
} HVTableViewOrientation;

@class HVTableView;

@protocol HVTableViewDelegate <NSObject>
@required
- (UIView *)hvTableView:(HVTableView *)hvTableView viewForRect:(CGRect)rect;
- (void)hvTableView:(HVTableView *)hvTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath*)indexPath;
@optional
- (void)hvTableView:(HVTableView *)hvTableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView;
- (void)hvTableView:(HVTableView *)hvTableView scrolledToOffset:(CGPoint)contentOffset;
- (void)hvTableView:(HVTableView *)hvTableView scrolledToFraction:(CGFloat)fraction;
- (NSUInteger)numberOfSectionsInHVTableView:(HVTableView*)hvTableView;
- (NSUInteger)numberOfCellsForHVTableView:(HVTableView *)view inSection:(NSInteger)section;
- (UIView*)hvTableView:(HVTableView*)hvTableView viewForHeaderInSection:(NSInteger)section;
- (UIView*)hvTableView:(HVTableView*)hvTableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)hvTableView:(HVTableView *)hvTableView heightOrWidthForCellAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface HVTableView : UIView <UITableViewDelegate, UITableViewDataSource> {
@private
	CGFloat		_cellWidthOrHeight;
	NSUInteger	_numItems;
}

@property (nonatomic, unsafe_unretained) id<HVTableViewDelegate> delegate;
@property (nonatomic, readonly, unsafe_unretained) UITableView *tableView;
@property (nonatomic, readonly, unsafe_unretained) NSArray *visibleViews;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) UIColor *cellBackgroundColor;
@property (nonatomic, readonly) HVTableViewOrientation orientation;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) NSUInteger numberOfCells;

- (id)initWithFrame:(CGRect)frame numberOfColumns:(NSUInteger)numCells ofWidth:(CGFloat)cellWidth;
- (id)initWithFrame:(CGRect)frame numberOfRows:(NSUInteger)numCells ofHeight:(CGFloat)cellHeight;

- (CGPoint)offsetForView:(UIView *)cell;
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;
- (void)setScrollFraction:(CGFloat)fraction animated:(BOOL)animated;
- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (UIView *)viewAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath*)indexPathForView:(UIView *)cell;
- (void)reloadData;

@end
