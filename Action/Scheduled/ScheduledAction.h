@interface ScheduledAction : NSObject

+(void) initializeScheduledTask ;
+(void) registerSchedule: (id)target timeElapsed:(float)timeElapsed repeats:(int)repeats ;
+(void) cancelSchedule: (id)target ;
+(void) cancelAllSchedule ;

+(void) start;
+(void) stop;
+(void) pause;
+(void) resume;

@end

@protocol ScheduledActionProtocal <NSObject>

@required
-(void) scheduledAction;

@end
