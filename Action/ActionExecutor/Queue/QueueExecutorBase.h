#import "ActionExecutorBase.h"

@interface QueueExecutorBase : ActionExecutorBase

#pragma mark - Public Methods

#pragma mark - Protect Methods

#pragma mark - required
-(void) applyKeyPath: (CAKeyframeAnimation*)animation ;

-(NSArray*) translateValues: (NSArray*)values ;

-(id) getEasingValue: (NSArray*)values index:(int)index nextIndex:(int)nextIndex argument:(double)argument ;

-(void) applyForwardWith: (id)forwardNum animation:(CAKeyframeAnimation*)animation view:(UIView*)view ;

#pragma mark - optional
-(void) extendTransitionWithMode: (int)transitionMode transitionList:(NSMutableArray*)transitionList values:(NSArray*)values from:(int)fromIndex to:(int)toIndex ;

@end
