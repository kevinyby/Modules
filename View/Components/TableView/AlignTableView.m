#import "AlignTableView.h"
#import "UIView+PropertiesSetter.h"


#import "_Frame.h"
#import "FrameHelper.h"
#import "FrameTranslater.h"

#import "_Helper.h"
#import "ArrayHelper.h"

#import "_Label.h"

@implementation AlignTableView

@synthesize headers;
@synthesize headersXcoordinates;
@synthesize valuesXcoordinates;


#pragma mark - UITableViewDataSource
//

#pragma mark - UITableViewDelegate
// this header is for sections, not for the whole table
// for the whole table , use HeaderTableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (! self.headers) return nil; // return nil , indicate that use the default section view.
    
    // we create the header view
    NSArray* sectionsHeaders = [ArrayHelper isTwoDimension: headers] ? [headers objectAtIndex: section] : headers;
    NSArray* sectionsHeaderCoordinates = [ArrayHelper isTwoDimension: headersXcoordinates] ? [headersXcoordinates objectAtIndex: section] : headersXcoordinates;
    
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5];
    [AlignTableView setAlignHeaders:tableView headerView:headerView headers:sectionsHeaders headersXcoordinates:sectionsHeaderCoordinates];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* coordinates = valuesXcoordinates ? valuesXcoordinates : headersXcoordinates;
    NSArray* valueXCoordinates = [ArrayHelper isTwoDimension: coordinates] ? [coordinates objectAtIndex: indexPath.section] : coordinates;
    [AlignTableView separateCellTextToAlignHeaders: self cell:cell valuesXcoordinates:valueXCoordinates];
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}







#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (UITableView*)tableView headerView:(UIView*)headerView headers:(NSArray*)headers headersXcoordinates:(NSArray*)headersXcoordinates
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
            
            // set frame by FrameHelper
            CGRect labelCanvas = [self getCanvas:label xcoordinates:headersXcoordinates index:i];
            [FrameHelper translateLabel: label canvas:labelCanvas];
        }
        
        // adjust width by text content
        label.text = labelText;
        [label adjustWidthToFontText];
    }
}


+ (void)separateCellTextToAlignHeaders: (UITableView*)tableView cell:(UITableViewCell*)cell valuesXcoordinates:(NSArray*)valuesXcoordinates
{
    cell.textLabel.hidden = YES;        // hide the original text
    NSString* cellText = cell.textLabel.text;
    
    NSArray* texts = [cellText componentsSeparatedByString: CELL_CONTENT_DELIMITER];
    int count = texts.count;        // == headers count
    
    // if not label , initialize the label
    for (int i = 0; i < count;  i++) {
        UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)] ;
        if (!label) {
            label = [[UILabel alloc] initWithText:nil];
            label.textAlignment = NSTextAlignmentLeft;
            // set font size
            float size = [FrameTranslater convertFontSize: 20];
            label.font = [UIFont systemFontOfSize: size];
            // adjust width by text content
            label.tag = CELL_CONTENT_LABEL_TAG(i);
            [cell.contentView addSubview:label];
            
            // set position
            CGRect labelCanvas = [self getCanvas:label xcoordinates:valuesXcoordinates index:i];
            [FrameHelper setFrame: labelCanvas view:label];
            [label setCenterY: [cell getSizeHeight]/2];
        }
    }
    
    // Pair A . first hidden , hide the label
    for (UIView* label in cell.contentView.subviews) {          // ios 7 [cell addSubview:label], the label add to the firstObject is [UITableViewCellScrollerView]
        if([label isKindOfClass: [UILabel class]]) {            // ios 6 no  problem ,add to cell , and its firstObject is [UITableViewCellContentView]
            if (label == cell.textLabel) continue;
            label.hidden = YES;
        }
    }
    
    // Pair B . second show , set the content
    for (int i = 0; i < count; i++) {
        UILabel* label = (UILabel*)[cell viewWithTag:CELL_CONTENT_LABEL_TAG(i)];
        label.hidden = NO;
        label.text = [texts objectAtIndex: i];
        // adjust width by text content
        [label adjustWidthToFontText];
    }
    
}


#pragma mark - Private Methods

+ (CGRect)getCanvas: (UILabel*)label xcoordinates:(NSArray*)xCoordinates index:(int)i {
    NSNumber* coordinate = xCoordinates.count > i ? [xCoordinates objectAtIndex: i] : nil;
    float coordinateX = coordinate ? [coordinate floatValue] : 200 * i;             // default interval 200
    CGRect labelCanvas = CGRectMake(coordinateX, 0, label.frame.size.width, 25);
    return labelCanvas;
}

@end
