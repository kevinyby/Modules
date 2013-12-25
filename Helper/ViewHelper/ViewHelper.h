#import <Foundation/Foundation.h>

@interface ViewHelper : NSObject

+(void) appendShadowView: (UIView*)view config:(NSDictionary*)config ;

+(void) sortedSubviewsByXCoordinate: (UIView*)view;


+(void) resignFirstResponserOnView: (UIView*)containerView;


+(void) tableViewRowInsert:(UITableView*)tableView insertIndexPaths:(NSArray*)insertIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion;


+(void) tableViewRowDelete:(UITableView*)tableView deleteIndexPaths:(NSArray*)deleteIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion;


#pragma mark - About Width
+(void) resizeWidthBySubviewsOccupiedWidth: (UIView*)superview;
+(float) getSubViewsOccupyLongestWidth: (UIView*)superView;

@end
