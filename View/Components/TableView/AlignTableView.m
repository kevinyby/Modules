#import "AlignTableView.h"
#import "UIView+PropertiesSetter.h"
#import "_Frame.h"
#import "_Helper.h"
#import "_Label.h"

@implementation AlignTableView

@synthesize headers;
@synthesize valuesXcoodinates;

#pragma mark - UITableViewDelegate
// this header is for sections, not for the whole table
// Use HeaderTable instead if you want a table header

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSArray* subHeaders = [ArrayHelper isTwoDimension: headers] ? [headers objectAtIndex: section] : headers;
//    NSArray* subHeaderCoordinates = [ArrayHelper isTwoDimension: valuesXcoodinates] ? [valuesXcoodinates objectAtIndex: section] : valuesXcoodinates;
//    
//    UIView* headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5];
//    [AlignTableView setAlignHeaders:headerView headers:subHeaders valuesXcoodinates:subHeaderCoordinates];
//    return headerView;
//}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView: tableViewObj cellForRowAtIndexPath:indexPath];
    
    NSString* text = cell.textLabel.text;
    cell.textLabel.hidden = YES;
    
     NSArray* subHeaderCoordinates = [ArrayHelper isTwoDimension: valuesXcoodinates] ? [valuesXcoodinates objectAtIndex: indexPath.section] : valuesXcoodinates;
    [AlignTableView separateCellTextToAlignHeaders:cell valuesXcoodinates:subHeaderCoordinates text:text];
    
    return cell;
}




#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (UIView*)headerView headers:(NSArray*)headers valuesXcoodinates:(NSArray*)valuesXcoodinates
{
    // set up contents & labels with x coordinate
    int count = headers.count;
    for (int i = 0; i < count; i++) {
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
        [self setFrame:label valuesXcoodinates:valuesXcoodinates index:i count:count];
        [label setOriginY: [FrameTranslater convertCanvasY:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone  ? 8 : 0]];
        
//         NSLog(@"header%@",NSStringFromCGPoint(label.center));
    }
}


+ (void)separateCellTextToAlignHeaders: (UITableViewCell*)cell valuesXcoodinates:(NSArray*)valuesXcoodinates text:(NSString*)text
{
    NSArray* texts = [text componentsSeparatedByString: CELL_CONTENT_DELIMITER];
    int count = texts.count;        // == headers count
        for (int i = 0; i < count;  i++) {
            
            // init label
            UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)] ;
            if (!label) {
                label = [[UILabel alloc] initWithText:nil];
                label.textAlignment = NSTextAlignmentCenter;
                // set font size
                label.font = [UIFont systemFontOfSize: 20];
                // adjust width by text content
                [label adjustWidth];
                label.tag = CELL_CONTENT_LABEL_TAG(i);
                [cell addSubview:label];
            }
            
            [self setFrame:label valuesXcoodinates:valuesXcoodinates index:i count:count];
            [label setOriginY: [FrameTranslater convertCanvasY: 10]];
        }
    
    
    for (int i = 0; i < count; i++) {
        UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)];
        label.text = [texts objectAtIndex: i];
        // adjust width by text content
        [label adjustWidth];
//        NSLog(@"-%@",NSStringFromCGPoint(label.center));
    }
    
}


+ (void) setFrame: (UILabel*)label valuesXcoodinates:(NSArray*)valuesXcoodinates index:(int)i count:(int)count {
    BOOL isCenterAlign = valuesXcoodinates.count == count + 1;      // TO BE IMPROVE
    BOOL isBetweenAlign = valuesXcoodinates.count == count * 2;     // TO BE IMPROVE
    
    float contentX = [self getXcoordinate: valuesXcoodinates index:i];
    if (isCenterAlign) {
        float contentNextX = [self getXcoordinate: valuesXcoodinates index:i + 1];
        contentX = (contentX + contentNextX) / 2;
    } else if (isBetweenAlign){
        contentX = [self getXcoordinate: valuesXcoodinates index:i * 2];
        float contentNextX = [self getXcoordinate: valuesXcoodinates index:i * 2 + 1];
        contentX = (contentX + contentNextX) / 2;
    }
    
    CGRect labelCanvas = CGRectMake(contentX, 0, label.frame.size.width, 25);
    [FrameHelper translateCanvas: labelCanvas view:label];
    if (isCenterAlign || isBetweenAlign) {
        [label setCenterX: [label.canvasFrame CGRectValue].origin.x];
    } else {
        label.frame = [label.canvasFrame CGRectValue];
    }
    
//    [ColorHelper setBorder:label];
    [FrameHelper translateFontLabel:label];     // the same as [FrameTranslater translateFontSize:]
}


+ (float)getXcoordinate: (NSArray*)valuesXcoodinates index:(int)index
{
    NSNumber* coordinate = valuesXcoodinates.count - 1 < index ? nil : [valuesXcoodinates objectAtIndex: index];
    float coordinateX = coordinate ? [coordinate floatValue] : 50;
    return coordinateX;
}

@end
