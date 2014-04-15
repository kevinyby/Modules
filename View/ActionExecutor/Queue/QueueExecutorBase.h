#import "ActionExecutorBase.h"




@class QueueExecutorBase;

@protocol QueueExecutorDelegate <NSObject>

-(void)queue:(QueueExecutorBase*)executor beginTimes:(NSArray*)beginTimes durations:(NSArray*)durations;

-(void)queueDidStart:(QueueExecutorBase*)executor animation:(CAAnimation *)anim;

-(void)queueDidStop:(QueueExecutorBase*)executor animation:(CAAnimation *)anim finished:(BOOL)flag;

@end







@interface QueueExecutorBase : ActionExecutorBase

@property (strong) id<QueueExecutorDelegate> delegate;



#pragma mark - Required Protect Methods
-(void) applyKeyPath: (CAKeyframeAnimation*)animation ;

-(NSArray*) translateValues: (NSArray*)values ;

-(id) getEasingValue: (NSArray*)values index:(int)index nextIndex:(int)nextIndex argument:(double)argument ;

-(void) applyForwardWith: (id)forwardNum animation:(CAKeyframeAnimation*)animation view:(UIView*)view ;


#pragma mark - Optional Protect Methods
-(void) extendTransitionWithMode: (int)transitionMode transitionList:(NSMutableArray*)transitionList values:(NSArray*)values from:(int)fromIndex to:(int)toIndex ;

@end
