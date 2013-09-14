#import "ScheduledAction.h"
#import "TaskObjectList.h"

@implementation ScheduledAction

static bool isBeing;
static bool isRunning;
static float timeDuration;
static float timeInterval;

static NSThread* scheduledThread;
static NSCondition* condition;
static bool locker;

static LinkList* taskObjectList ;    // TO BE OPTIMIZED , NOT THREAD SAFE

+(void) initializeScheduledTask {
    timeDuration = 0.0;
    timeInterval = 0.05;
    scheduledThread = [[NSThread alloc] initWithTarget: self selector:@selector(messageDispatcher) object:nil];
    condition = [[NSCondition alloc] init];
}

+(void) messageDispatcher {
    while (isRunning) {
        
        [condition lock];
        if (locker || !taskObjectList) {
            [condition wait];
        }
        [condition unlock];
        
//        NSLog(@" ----- ScheduledAction ------** ");
        timeDuration += timeInterval;
        TaskObject* p1 , *p0;
        p1 = taskObjectList;
        
        while (taskObjectList && p1 && timeDuration >= p1->timeInvoke) {
            id target = (__bridge id)(p1->target);
            
            if ([target conformsToProtocol: @protocol(ScheduledActionProtocal)] || [target respondsToSelector: @selector(scheduledAction)]) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [target performSelector: @selector(scheduledAction)];
                });
            }
            
            // < 0 , loop every timeElapsed
            if (p1->repeats < 0) {
                p1->timeInvoke += p1->timeElapsed;
                
                // > 0 , do accurate repeat times
            } else if (p1->repeats > 0) {
                p1->repeats -- ;
                p1->timeInvoke += p1->timeElapsed;
                
                // == 0 , remove from task list
            } else {
                if (p1 == taskObjectList) {
                    taskObjectList  = taskObjectList -> next;
                } else {
                    p0->next = p1->next;
                }
                free(p1);
                p1 = p0;
            }
            
            p0 = p1;
            p1 = p1->next;
        }
        
        [NSThread sleepForTimeInterval: timeInterval];
    }
}

/*
 
 repeats =< 0 : loop every timeElapsed
 
 < 0 : perform immediately  , loop
 = 0 : perform after one timeElapsed , loop
 
 repeats > 0 : repeate accurate repeat times , and perform after one timeElapsed
 
 */
+(void) registerSchedule: (id)target timeElapsed:(float)timeElapsed repeats:(int)repeats {
    TaskObject* taskObject = CreateTaskObject((__bridge void*)target, timeElapsed, repeats);
    if (taskObject->timeElapsed < 0.05) taskObject->timeElapsed = 0.05;
    float invokeTime = repeats < 0 ? timeDuration : timeDuration + timeElapsed;
    taskObject->timeInvoke = invokeTime;
    taskObject->next = NULL;
    
//    taskObjectList = ListDelete(taskObjectList, target);   // only one target in list
    if (!taskObjectList) [self resume];
    taskObjectList = InsertList(taskObjectList, taskObject);
}

+(void) cancelSchedule: (id)target {
    taskObjectList = ListDelete(taskObjectList, (__bridge void *)(target));
}

+(void) cancelAllSchedule {
    [self pause];
    taskObjectList = ClearList(taskObjectList);
}

+(void) start {
    if (! isBeing) {
        isRunning = YES;
        [scheduledThread start];
        isBeing = YES;
    }else {
        [self resume];
    }
}

+(void) stop {
    isRunning = NO;
}

+(void) pause {
    locker = YES;
}

+(void) resume {
    [condition lock];
    locker = NO;
    [condition signal];
    [condition unlock];
}

@end