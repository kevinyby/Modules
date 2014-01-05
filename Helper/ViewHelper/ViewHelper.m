#import "ViewHelper.h"
#import <QuartzCore/QuartzCore.h>

#import "UIView+PropertiesSetter.h"

@implementation ViewHelper


+(void) logViewRecursive: (UIView*)view
{
    NSLog(@"%@", view);
    for (UIView* subview in view.subviews) {
        [ViewHelper logViewRecursive: subview];
    }
}


+ (void) setCornerRadius: (UIView*)view config:(NSDictionary*)config
{
    NSNumber* radiusNumber = config[@"CornerRadius"];
    float cornerRadius = radiusNumber ? [radiusNumber floatValue] : 10.0f;
    view.layer.cornerRadius = cornerRadius ;
    view.clipsToBounds = YES;
}

/**
 * This method just make you know that , if you want radius(cause you have to set clipsToBounds/setMasksToBounds YES) and shadow exist at the same time
 * For the setMasksToBounds and clipsToBounds sake , they cannot exist at the same time 
 * So , you should create a shadow view to show the shadow for your view(cornerRadius and clipsToBounds/masksToBounds)
 *
 * the view should have frame first.
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



#pragma mark - About View Hierarchy

+(UIView*) getTopView
{
    UIViewController* rootViewController = [self getRootViewController];
    UIView* topView = nil ;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        topView = ((UINavigationController*)rootViewController).topViewController.view;
    } else {
        topView = rootViewController.view;
    }
    return topView;
}

+(UIView*) getRootView
{
    return [[[[UIApplication sharedApplication] keyWindow] subviews] firstObject];
}

+(UIViewController*) getRootViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

+(CGRect) getScreenBoundsByOrientation
{
    CGRect screenSize = [UIScreen mainScreen].bounds;
    float screenWidth = screenSize.size.width;
    float screenHeight = screenSize.size.height;
    
    UIViewController* rootViewController = [self getRootViewController];
    UIInterfaceOrientation orientation = rootViewController.interfaceOrientation;
    CGRect rect = UIInterfaceOrientationIsPortrait(orientation) ? (CGRect){{0,0},{screenWidth,screenHeight}} : (CGRect){{0,0},{screenHeight,screenWidth}};
    return rect;
}



#pragma mark - About Width
// i.e. when you chang localize text in label
// the width of the label change, you can invoke this to fix
// resize it recursive
+(void) resizeWidthBySubviewsOccupiedWidth: (UIView*)superview
{
    for (UIView* view in superview.subviews) {
        [ViewHelper resizeWidthBySubviewsOccupiedWidth: view];
    }
    
    float width = [ViewHelper getSubViewsOccupyLongestWidth: superview];
    // must have subviews
    //    if (superview.subviews.count) [superview setSizeWidth: width];
    if (width != 0) [superview setSizeWidth: width];    // the same as above
}

// superview must have subviews
+(float) getSubViewsOccupyLongestWidth: (UIView*)superView
{
    return [ViewHelper getSubViewsOccupyLongestWidth: superView originX:0];
}

+(float) getSubViewsOccupyLongestWidth: (UIView*)originView originX: (float)originX
{
    float width = 0.0f;
    for (UIView* subview in originView.subviews) {
        float right = 0.0f;
        
        if (subview.subviews.count != 0) {
            float x = [subview getOriginX] + originX;
            right = [ViewHelper getSubViewsOccupyLongestWidth: subview originX: x];
        } else {
            right = [subview getOriginX] + [subview getSizeWidth] + originX;
        }
        
        width = width < right ? right : width;
    }
    
    return width;
}



#pragma mark - About Subviews

+(void) iterateSubView: (UIView*)superView class:(Class)clazz handler:(BOOL (^)(id subView))handler {
    for (UIView* subView in [superView subviews]) {
        if ([subView isKindOfClass:clazz]) {
            if (handler(subView)) return;
        } else {
            [ViewHelper iterateSubView: subView class:clazz handler:handler];
        }
    }
}

+(void) iterateSubView: (UIView*)superView classes:(NSArray*)clazzes handler:(void (^)(id subView))handler {
    for (UIView* subView in [superView subviews]) {
        BOOL flag = NO;
        for (Class clazz in clazzes) {
            flag = [subView isKindOfClass: clazz];
            if (flag) break;
        }
        if (flag) {
            handler(subView);
        } else {
            [ViewHelper iterateSubView: subView classes:clazzes handler:handler];
        }
    }
}

@end
