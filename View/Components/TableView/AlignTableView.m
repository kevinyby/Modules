#import "AlignTableView.h"
#import "FrameHelper.h"
#import "ArrayHelper.h"
#import "UILabel+AdjustWidth.h"

@implementation AlignTableView

@synthesize headers;
@synthesize headersXcoodinates;

#pragma mark - UITableViewDelegate
// this header is for sections, not for the whole table
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSArray* subHeaders = [ArrayHelper isTwoDimension: headers] ? [headers objectAtIndex: section] : headers;
//    NSArray* subHeaderCoordinates = [ArrayHelper isTwoDimension: headersXcoodinates] ? [headersXcoodinates objectAtIndex: section] : headersXcoodinates;
//    return [AlignTableView createDefaultHeaderView:subHeaders headersXcoodinates:subHeaderCoordinates];
//}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView: tableViewObj cellForRowAtIndexPath:indexPath];
    
    NSString* text = cell.textLabel.text;
    cell.textLabel.hidden = YES;
    
     NSArray* subHeaderCoordinates = [ArrayHelper isTwoDimension: headersXcoodinates] ? [headersXcoodinates objectAtIndex: indexPath.section] : headersXcoodinates;
    [AlignTableView separateCellTextToAlignHeaders:cell headersXcoodinates:subHeaderCoordinates text:text];
    
    return cell;
}




#pragma mark - AlignTableView Class Object Methods

+ (UIView*)createDefaultHeaderView: (NSArray*)headers headersXcoodinates:(NSArray*)headersXcoodinates
{
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5];
    [AlignTableView setAlignHeaders:headerView headers:headers headersXcoodinates:headersXcoodinates];
    return headerView;
}

+ (void)setAlignHeaders: (UIView*)headerView headers:(NSArray*)headers headersXcoodinates:(NSArray*)headersXcoodinates
{
    // set up contents & labels with x coordinate
    for (int i = 0; i < headers.count; i++) {
        float contentX = [self getXcoordinate: headersXcoodinates index:i];
        NSString* labelText = [headers objectAtIndex:i];
        
        // init label
        UILabel* label = (UILabel*)[headerView viewWithTag:HEADER_CONTENT_LABEL_TAG(i)];
        if (!label) {
           label = [[UILabel alloc] initWithText:labelText];
            label.tag = HEADER_CONTENT_LABEL_TAG(i);
            [headerView addSubview:label];
        }
        
        // adjust width by text content
        label.text = labelText;
        [label adjustWidth];
        
        // set frame by FrameHelper
        CGRect labelCanvas = CGRectMake(contentX, [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone  ? 8 : 0, label.frame.size.width, 25);
        [FrameHelper setFrame:labelCanvas view:label];
        [FrameHelper translateFontLabel:label];
        
    }
}


+ (void)separateCellTextToAlignHeaders: (UITableViewCell*)cell headersXcoodinates:(NSArray*)headersXcoodinates text:(NSString*)text
{
    NSArray* texts = [text componentsSeparatedByString: CELL_CONTENT_DELIMITER];
    int count = texts.count;
        for (int i = 0; i < count;  i++) {
            float contentX = [self getXcoordinate: headersXcoodinates index:i];
            
            // init label
            UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)] ;
            if (!label) {
                label = [[UILabel alloc] initWithText:nil];
                label.textAlignment = NSTextAlignmentLeft;
                // set font size
                label.font = [UIFont systemFontOfSize: 20];
                // adjust width by text content
                [label adjustWidth];
                label.tag = CELL_CONTENT_LABEL_TAG(i);
                [cell addSubview:label];
            }
            
            CGRect labelCanvas= CGRectMake(contentX, 10, label.frame.size.width, 25);
            [FrameHelper setFrame:labelCanvas view:label];
            [FrameHelper translateFontLabel:label];     // the same as [FrameTranslater translateFontSize:]
        }
    
    
    for (int i = 0; i < count; i++) {
        UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)];
        label.text = [texts objectAtIndex: i];
        // adjust width by text content
        [label adjustWidth];
    }
}


+ (float)getXcoordinate: (NSArray*)headersXcoodinates index:(int)index
{
    NSNumber* coordinate = headersXcoodinates.count - 1 < index ? nil : [headersXcoodinates objectAtIndex: index];
    float coordinateX = coordinate ? [coordinate floatValue] : 30;
    return coordinateX;
}

@end
