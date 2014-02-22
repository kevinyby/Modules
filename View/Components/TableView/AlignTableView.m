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

@synthesize headersYcoordinates;
@synthesize valuesYcoordinates;

#pragma mark - UITableViewDataSource
//

#pragma mark - UITableViewDelegate
// this header is for sections, not for the whole table
// for the whole table , use HeaderTableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (! self.headers) return nil; // return nil , indicate that use the default section view.
    
    // we create the header view
    NSArray* sectionsHeaders = [ArrayHelper isTwoDimension: headers] ? [headers objectAtIndex: section] : headers;
    NSArray* sectionsHeaderXCoordinates = [ArrayHelper isTwoDimension: headersXcoordinates] ? [headersXcoordinates objectAtIndex: section] : headersXcoordinates;
    NSArray* sectionsHeaderYCoordinates = [ArrayHelper isTwoDimension: headersYcoordinates] ? [headersYcoordinates objectAtIndex: section] : headersYcoordinates;
    
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5];
    [AlignTableView setAlignHeaders:tableView headerView:headerView headers:sectionsHeaders headersXcoordinates:sectionsHeaderXCoordinates headersYcoordinates:sectionsHeaderYCoordinates];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    valuesXcoordinates = valuesXcoordinates ? valuesXcoordinates : headersXcoordinates;
    NSArray* valueXCoordinates = [ArrayHelper isTwoDimension: valuesXcoordinates] ? [valuesXcoordinates objectAtIndex: indexPath.section] : valuesXcoordinates;
    NSArray* valueYCoordinates = [ArrayHelper isTwoDimension: valuesYcoordinates] ? [valuesYcoordinates objectAtIndex: indexPath.section] : valuesYcoordinates;
    
    [AlignTableView separateCellTextToAlignHeaders: self cell:cell valuesXcoordinates:valueXCoordinates valuesYcoordinates:valueYCoordinates];
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}







#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (UITableView*)tableView headerView:(UIView*)headerView headers:(NSArray*)headers headersXcoordinates:(NSArray*)headersXcoordinates headersYcoordinates:(NSArray*)headersYcoordinates
{
    int count = headers.count;
    // set up contents & labels with x coordinate
    for (int i = 0; i < count; i++) {
        NSString* labelText = [headers objectAtIndex:i];
        
        // init label
        UILabel* label = (UILabel*)[headerView viewWithTag:HEADER_CONTENT_LABEL_TAG(i)];
        if (!label) {
            label = [[UILabel alloc] initWithText:labelText];
            [self setLabelDefaultProperties: label];
            label.tag = HEADER_CONTENT_LABEL_TAG(i);
            [headerView addSubview:label];
        }
        
        
        // set frame
        CGRect labelCanvas = [self getLabelCanvas:i xCoordinates:headersXcoordinates yCoordinates:headersYcoordinates];
        [FrameHelper setFrame: labelCanvas view:label];
        
        // adjust width by text content
        label.text = labelText;
        [label adjustWidthToFontText];
    }
}


+ (void)separateCellTextToAlignHeaders: (UITableView*)tableView cell:(UITableViewCell*)cell valuesXcoordinates:(NSArray*)valuesXcoordinates valuesYcoordinates:(NSArray*)valuesYcoordinates
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
            [self setLabelDefaultProperties: label];
            label.tag = CELL_CONTENT_LABEL_TAG(i);
            [cell.contentView addSubview:label];
            
            // set frame
            CGRect labelCanvas = [self getLabelCanvas:i xCoordinates:valuesXcoordinates yCoordinates:valuesYcoordinates];
            [FrameHelper setFrame: labelCanvas view:label];
            if (! valuesYcoordinates) {
//                [label setCenterY: [label.superview getSizeHeight]/2];        // Apple's Badddddddddddly ... code .
                [label setCenterY: [tableView.delegate tableView: tableView heightForRowAtIndexPath:[tableView indexPathForCell: cell]] / 2];
            }
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

+ (void)setLabelDefaultProperties: (UILabel*)label
{
    label.textAlignment = NSTextAlignmentLeft;
    // set font size
    float size = [FrameTranslater convertFontSize: 20];
    label.font = [UIFont systemFontOfSize: size];
}

+ (CGRect)getLabelCanvas: (int)index xCoordinates:(NSArray*)xCoordinates yCoordinates:(NSArray*)yCoordinates {
    NSNumber* xNum = xCoordinates.count > index ? [xCoordinates objectAtIndex: index] : nil;
    float coordinateX = xNum ? [xNum floatValue] : 200 * index;             // default interval 200
    
    int temp = index;
    NSNumber* yNum = nil;
    while (temp >= 0 && !yNum) {
        yNum = yCoordinates.count > temp ? [yCoordinates objectAtIndex: temp] : nil;
        temp--;
    }
    float coordinateY = yNum ? [yNum floatValue] : 0;                       // default get the last one
    
    CGRect labelCanvas = CGRectMake(coordinateX, coordinateY, 25, 25);
    return labelCanvas;
}

@end
