#import <Foundation/Foundation.h>

@interface ViewHelper : NSObject

+(void) logViewRecursive: (UIView*)view;

+ (void) setCornerRadius: (UIView*)view config:(NSDictionary*)config;
+(void) appendShadowView: (UIView*)view config:(NSDictionary*)config ;

+(void) sortedSubviewsByXCoordinate: (UIView*)view;


+(void) resignFirstResponserOnView: (UIView*)containerView;


+(void) tableViewRowInsert:(UITableView*)tableView insertIndexPaths:(NSArray*)insertIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion;


+(void) tableViewRowDelete:(UITableView*)tableView deleteIndexPaths:(NSArray*)deleteIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion;



#pragma mark - About View Hierarchy
+(UIView*) getTopView;
+(UIView*) getRootView;
+(CGRect) getScreenBoundsByOrientation;
+(UIViewController*) getRootViewController;


#pragma mark - About Width
+(void) resizeWidthBySubviewsOccupiedWidth: (UIView*)superview;
+(float) getSubViewsOccupyLongestWidth: (UIView*)superView;


#pragma mark - About Subviews
+(void) iterateSubView: (UIView*)superView class:(Class)clazz handler:(BOOL (^)(id subView))handler ;
+(void) iterateSubView: (UIView*)superView classes:(NSArray*)clazzes handler:(void (^)(id subView))handler ;

@end
