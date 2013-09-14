#import "TimeMachine.h"

#define TARGET @"TARGET"
#define ACTION @"ACTION"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation TimeMachine

@synthesize worldTimer;
@synthesize timeInterval;

-(id) initWithInterval: (CGFloat)interval {
    self = [super init];
    if (self) {
        self.timeInterval = interval;
        self.worldTimer = [NSTimer timerWithTimeInterval: timeInterval
                                                  target: self
                                                selector: @selector(messageDispatcher)
                                                userInfo: nil
                                                 repeats: YES];
        repeatEventList = [[NSMutableDictionary alloc] init];
        singleEventList = [[NSMutableSet alloc] init];
        begining = YES;
    }
    return self;
}


-(void) messageDispatcher {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //check single event
        NSMutableSet* removingSet = [NSMutableSet set];
        for (NSArray* eventChain in singleEventList) {
            int delayTick = [[eventChain lastObject] intValue];
            if (delayTick == timeElapsedCount) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    id target = [eventChain objectAtIndex: 0];
                    NSString* action = [eventChain objectAtIndex: 1];
                    [target performSelector: NSSelectorFromString(action)];
                });
                [removingSet addObject: eventChain];
            }
        }
        [singleEventList minusSet: removingSet];
        
        //check repeat event
        for (NSNumber* timeNumber in repeatEventList) {
            if (timeElapsedCount % timeNumber.intValue == 0) {
                NSArray* eventGroup = [repeatEventList objectForKey: timeNumber];
                for (NSDictionary* event in eventGroup) {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        id target = [event objectForKey: TARGET];
                        SEL action = NSSelectorFromString([event objectForKey: ACTION]);
                        [target performSelector: action];
                    });
                }
            }
        }
        
        timeElapsedCount++;
    });
}

-(void) registerRepeatEvent: (id)target action:(SEL)action tick:(int)tick {
    NSMutableDictionary* event = [NSMutableDictionary dictionary];
    [event setObject: target forKey: TARGET];
    [event setObject: NSStringFromSelector(action) forKey: ACTION];
    
    NSNumber* eventNumber = [NSNumber numberWithInt: tick];
    if ([repeatEventList objectForKey: eventNumber] == nil) {
        NSMutableArray* eventGroup = [NSMutableArray array];
        [eventGroup addObject: event];
        [repeatEventList setObject: eventGroup forKey: eventNumber];
    }else {
        NSMutableArray* eventGroup = [repeatEventList objectForKey: eventNumber];
        [eventGroup addObject: event];
    }
}

-(void) registerSingleEvent: (id)target action:(SEL)action afterDelay:(NSTimeInterval)duration {
    int delayTick = (float)duration / self.timeInterval;
    delayTick += timeElapsedCount;
    
    NSMutableArray* eventChain = [NSMutableArray arrayWithObjects: target,
                                                                   NSStringFromSelector(action),
                                                                   [NSNumber numberWithInt: delayTick], nil];
    [singleEventList addObject: eventChain];
}

// if action == nil , then cancel all action on this target
-(void) cancleRepeatTarget: (id)target action:(SEL)action {
    for (NSNumber* timeNumber in repeatEventList) {
        NSMutableArray* eventGroup = [repeatEventList objectForKey: timeNumber];
        NSMutableArray* minusTarget = [NSMutableArray array];
        for (NSDictionary* event in eventGroup) {
            id targetObj = [event objectForKey: TARGET];
            if (targetObj != target) continue;
            
            if (!action) {
                [minusTarget addObject: event];
            } else {
                SEL actionObj = NSSelectorFromString([event objectForKey: ACTION]);
                if (action == actionObj) [minusTarget addObject: event];
            }
        }
        for (id event in minusTarget) {
            [eventGroup removeObject: event];
        }
    }
}

-(void) cancleSingleTarget: (id)target action:(SEL)action {
    NSMutableSet* removingSet = [NSMutableSet set];
    for (NSArray* eventChain in singleEventList) {
        id targetObj = [eventChain objectAtIndex: 0];
        if (targetObj != target) continue;
        if (! action) {
            [removingSet addObject: eventChain];
        } else {
            SEL actionObj = NSSelectorFromString([eventChain objectAtIndex: 1]);
            if (action == actionObj)[removingSet addObject: eventChain];
        }
    }
    [singleEventList minusSet: removingSet];
}

-(void) cancleAllEvents {
    [repeatEventList removeAllObjects];
    [singleEventList removeAllObjects];
}

-(void) begin {
    if (begining) {
        [[NSRunLoop mainRunLoop] addTimer: self.worldTimer forMode: NSRunLoopCommonModes];
        begining = NO;
    }else {
        [self resume];
    }
}

-(void) stop {
    if (![self.worldTimer isValid]) return;
    [self.worldTimer invalidate];
}

-(void) pause {
    [self.worldTimer setFireDate: [NSDate distantFuture]];
}

-(void) resume {
    [self.worldTimer setFireDate: [NSDate date]];
}

@end
