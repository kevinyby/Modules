#import "ViewHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewHelper

/**
 * This method just make you know that , if you want radius and shadow exist at the same time
 * For the setMasksToBounds and clipsToBounds sake , they cannot exist at the same time 
 * So , you should create a shadow view to show the shadow
 */
+ (void) appendShadowView: (UIView*)view config:(NSDictionary*)config
{
    UIView *superView = view.superview;
    
    CGRect oldBackgroundFrame = view.frame;
    [view removeFromSuperview];
    
    // get parameters
    NSNumber* shadowOpacityValue = [config objectForKey: @"ShadowOpacity"];
    float shadowOpacity = shadowOpacityValue ? [shadowOpacityValue floatValue] : 1.0f;
    NSNumber* shadowRadiusValue = [config objectForKey: @"ShadowRadius"];
    float shadowRadius = shadowRadiusValue ? [shadowRadiusValue floatValue] : 5.0f;
    NSValue* shadowOffsetValue = [config objectForKey: @"ShadowOffset"];
    CGSize shadowOffset = [shadowOffsetValue CGSizeValue];
    
    CGRect frameForShadowView = CGRectMake(0, 0, oldBackgroundFrame.size.width, oldBackgroundFrame.size.height);
    UIView *shadowView = [[UIView alloc] initWithFrame:frameForShadowView];
    [shadowView.layer setShadowOpacity: shadowOpacity];
    [shadowView.layer setShadowRadius: shadowRadius];
    [shadowView.layer setShadowOffset: shadowOffset];
    
    [shadowView addSubview:view];
    [superView addSubview:shadowView];
    
}

/**
 *   Sort the view.subviews index by subview.frame.origin.x coordinate
 */
+(void) sortedSubviewsByXCoordinate: (UIView*)containerView
{
    // sort subviews
    NSMutableArray* array = [NSMutableArray arrayWithArray: containerView.subviews];
    NSArray* sorteArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view = (UIView*)obj1;
        UIView* nextView = (UIView*)obj2;
        float viewOriginX = view.frame.origin.x;
        float nextViewOriginX = nextView.frame.origin.x;
        return [[NSNumber numberWithFloat: viewOriginX] compare: [NSNumber numberWithFloat: nextViewOriginX]];
    }];
    
    // reset index
    for (int i = 0; i < sorteArray.count; i++) {
        UIView* view = sorteArray[i];
        [containerView insertSubview: view atIndex:i];
    }
}

/**
 *  make the fist responser(u don't know who) loose it focus
 *
 *  @param containerView the view visible
 */
+(void) resignFirstResponserOnView: (UIView*)containerView
{
    // just a trick , make the fist responser(u don't know who) loose it focus
    UITextField* invisibleTextField = [[UITextField alloc] init];
    invisibleTextField.hidden = YES;
    invisibleTextField.frame = CGRectZero;
    [containerView addSubview: invisibleTextField];
    [invisibleTextField becomeFirstResponder];
    [invisibleTextField resignFirstResponder];
    [invisibleTextField removeFromSuperview];
}


+(void) tableViewRowInsert:(UITableView*)tableView insertIndexPaths:(NSArray*)insertIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion
{
    tableView.bounces = NO;
    [UIView animateWithDuration:0.5
                     animations:^(){
                         // Perform insertRowsAtIndexPaths here
                         [tableView beginUpdates];
                         [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:animation];
                         [tableView endUpdates];
                     }
                     completion:^(BOOL finished) {
                         // This will be called when the animation is complete
                         tableView.bounces = YES;
                         if (completion) completion(finished);
                     }];
}

+(void) tableViewRowDelete:(UITableView*)tableView deleteIndexPaths:(NSArray*)deleteIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion
{
    tableView.bounces = NO;
    [UIView animateWithDuration:0.5
                     animations:^(){
                         // Perform insertRowsAtIndexPaths here
                         [tableView beginUpdates];
                         [tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:animation];
                         [tableView endUpdates];
                     }
                     completion:^(BOOL finished) {
                         // This will be called when the animation is complete
                         tableView.bounces = YES;
                         if (completion) completion(finished);
                     }];
}

@end
