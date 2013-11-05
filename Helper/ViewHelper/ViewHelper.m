#import "ViewHelper.h"

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

@end
