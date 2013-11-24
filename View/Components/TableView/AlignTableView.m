#import "AlignTableView.h"
#import "UIView+PropertiesSetter.h"
#import "_Frame.h"
#import "_Helper.h"
#import "_Label.h"

@implementation AlignTableView

@synthesize headers;
@synthesize headersXcoordinates;
@synthesize valuesXcoordinates;

#pragma mark - UITableViewDelegate
// this header is for sections, not for the whole table
// Use HeaderTable instead if you want a table header

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSArray* subHeaders = [ArrayHelper isTwoDimension: headers] ? [headers objectAtIndex: section] : headers;
//    NSArray* subHeaderCoordinates = [ArrayHelper isTwoDimension: headersXcoordinates] ? [headersXcoordinates objectAtIndex: section] : headersXcoordinates;
//    
//    UIView* headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5];
//    [AlignTableView setAlignHeaders:headerView headers:subHeaders valuesXcoordinates:subHeaderCoordinates];
//    return headerView;
//}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView: tableViewObj cellForRowAtIndexPath:indexPath];
    
    NSString* cellText = cell.textLabel.text;
    cell.textLabel.hidden = YES;
    
     NSArray* subHeaderCoordinates = [ArrayHelper isTwoDimension: valuesXcoordinates] ? [valuesXcoordinates objectAtIndex: indexPath.section] : valuesXcoordinates;
    [AlignTableView separateCellTextToAlignHeaders:cell valuesXcoordinates:subHeaderCoordinates text:cellText];
    
    return cell;
}



#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (UIView*)headerView headers:(NSArray*)headers headersXcoordinates:(NSArray*)headersXcoordinates
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
        [label adjustWidthToFontText];
        
        // set frame by FrameHelper
        CGRect labelCanvas = [self getCanvas:label xcoordinates:headersXcoordinates index:i];
        [FrameHelper translateLabel: label canvas:labelCanvas];
        [label setOriginY: [FrameTranslater convertCanvasY:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone  ? 0 : 8]];
    }
}


+ (void)separateCellTextToAlignHeaders: (UITableViewCell*)cell valuesXcoordinates:(NSArray*)valuesXcoordinates text:(NSString*)text
{
    NSArray* texts = [text componentsSeparatedByString: CELL_CONTENT_DELIMITER];
    int count = texts.count;        // == headers count
        for (int i = 0; i < count;  i++) {
            
            // init label
            UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)] ;
            if (!label) {
                label = [[UILabel alloc] initWithText:nil];
                label.textAlignment = NSTextAlignmentLeft;
                // set font size
                float size = [FrameTranslater convertFontSize: 20];
                label.font = [UIFont systemFontOfSize: size];
                // adjust width by text content
                label.tag = CELL_CONTENT_LABEL_TAG(i);
                [cell addSubview:label];
            }
            
            CGRect labelCanvas = [self getCanvas:label xcoordinates:valuesXcoordinates index:i];
            [FrameHelper setFrame: labelCanvas view:label];
            [label setOriginY: [FrameTranslater convertCanvasY: 10]];
        }
    
    
    for (int i = 0; i < count; i++) {
        UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)];
        label.text = [texts objectAtIndex: i];
        // adjust width by text content
        [label adjustWidthToFontText];
    }
    
}


+ (CGRect)getCanvas: (UILabel*)label xcoordinates:(NSArray*)xCoordinates index:(int)i {
    NSNumber* coordinate = xCoordinates.count > i ? [xCoordinates objectAtIndex: i] : nil;
    float coordinateX = coordinate ? [coordinate floatValue] : 100 * i;
    CGRect labelCanvas = CGRectMake(coordinateX, 0, label.frame.size.width, 25);
    return labelCanvas;
}

@end
