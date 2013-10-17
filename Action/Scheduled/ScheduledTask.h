@interface ScheduledTask : NSObject

-(id) initWithTimeInterval: (float)interval ;
-(void) registerSchedule: (id)target timeElapsed:(float)timeElapsed repeats:(int)repeats ;
-(void) cancelSchedule: (id)target ;
-(void) cancelAllSchedule ;

-(void) start;
-(void) stop;
-(void) pause;
-(void) resume;

@end


@protocol ScheduledTaskProtocol <NSObject>

@required
-(void) scheduledTask ;

@end