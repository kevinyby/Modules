#import "QueueExecutorBase.h"
#import "QueueExecutorHelper.h"
#import "EaseFunction.h"

#define defaultStepTime 0.05

@implementation QueueExecutorBase

@synthesize delegate;

-(void) execute:(NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times {
    NSMutableArray* durations = [NSMutableArray array];
    NSMutableArray* beginTimes = [NSMutableArray array];
    
    // a queue
    if (! [[objects firstObject] isKindOfClass: [NSArray class]]) {
        
        [self execute: config views:objects values:values times:times durationsRep:durations beginTimesRep:beginTimes];
        
    } else {
        
        // a matrix
        NSNumber* stepTimeNum = [config objectForKey: @"stepTime"];
        double stepTime = stepTimeNum ? [stepTimeNum floatValue] : defaultStepTime;
        
        NSNumber* delayNumber = [config objectForKey: @"matrix.delayRelativeToMilestone"];
        int delayCount = delayNumber ? [delayNumber intValue] : 0;
        double delayTime = stepTime * delayCount;                   // the resutl we need first
        
        NSNumber* intervalNumber = [config objectForKey: @"matrix.delayRelativeToQueueIndex"];
        int intervalCount = intervalNumber ? [intervalNumber  intValue] : 0;
        
        int queueCount = objects.count;
        for (int i = 0; i < queueCount; i++) {
            NSArray* innerViews = [objects objectAtIndex: i];
            NSArray* innerValues = [values objectAtIndex: i];
            NSMutableArray* innerTimes = i < times.count ? [times objectAtIndex: i] : nil;
            
            int interval = intervalCount;
            interval = interval < 0 ? abs(interval) * (queueCount - i - 1) : interval * i;
            double intervalTime = stepTime * interval;              // the resutl we need second
            
            double incrementTime = intervalTime + delayTime;        // the resutl we need , we have to do is caculate the new baseTime values
            if (incrementTime != 0) {
                int objectCount = innerViews.count;
                innerTimes = innerTimes ? innerTimes : [NSMutableArray arrayWithCapacity: objectCount];
                for (int j = 0; j < objectCount; j++) {
                    NSNumber* baseTimeNumOld = j < innerTimes.count ? [innerTimes objectAtIndex: j] : nil ;
                    double exBaseTime = [baseTimeNumOld doubleValue];
                    NSNumber* baseTimeNumNew = [NSNumber numberWithFloat: exBaseTime + incrementTime];
                    j < innerTimes.count ? [innerTimes replaceObjectAtIndex: j withObject:baseTimeNumNew] : [innerTimes addObject: baseTimeNumNew];
                }
            }
            
            // for the return value
            NSMutableArray* innerDurations = [NSMutableArray array];
            NSMutableArray* innerBeginTimes = [NSMutableArray array];
            [durations addObject: innerDurations];
            [beginTimes addObject: innerBeginTimes];
            [self execute: config views:innerViews values:innerValues times:innerTimes durationsRep:innerDurations beginTimesRep:innerBeginTimes];
        }
        
    }
    
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(queue:beginTimes:durations:)]) {
        [delegate queue: self beginTimes:beginTimes durations:durations];
    }
    
}

/*
 the last obj in views will go to the position which is the last obj in values
 and the views.count <= values.count , views.count == baseTimes.count or baseTimes is nil
 */
-(void) execute: (NSDictionary*)config views:(NSArray*)views values:(NSArray*)values times:(NSArray*)times durationsRep:(NSMutableArray*)durationsQueue beginTimesRep:(NSMutableArray*)beginTimesQueue {
    if ( (values && values.count < views.count) || views.count == 0) return;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
    [self applyKeyPath: animation];
    animation.delegate = self;
    animation.autoreverses = [[config objectForKey: @"reverse"] boolValue];
    float repeatCount = [[config objectForKey: @"repeatCount"] floatValue];
    animation.repeatCount = repeatCount < 0 ? HUGE_VALF : repeatCount;
    animation.repeatDuration = [[config objectForKey: @"repeatDuration"] doubleValue];
    
    int emptyIndividual = 0 ;
    int viewsCount = views.count;
    int valuesCount = values.count;
    int offset = valuesCount - viewsCount;
    BOOL isBaseTimeEmpty = times ? times.count == 0 : YES;
    
    NSNumber* stepTimeNum = [config objectForKey: @"stepTime"];
    double stepTime = stepTimeNum ? [stepTimeNum floatValue] : defaultStepTime;
    float elementStartingOffset = [[config objectForKey: @"element.startingOffset"] floatValue];
    double totalTime = [[config objectForKey: @"element.totalTransitTime"] doubleValue] ;
    BOOL isByTotal = totalTime > 0 ;
    BOOL isLeaveEmpty = [[config objectForKey: @"queue.isLeaveEmpty"] boolValue];
    
    NSArray* realValues = [self translateValues: values];
    
    for (int i = viewsCount-1; i >= 0; i--) {
        UIView* view = [views objectAtIndex: i];
        if (! [view isKindOfClass: [UIView class]]) {
            if (! isLeaveEmpty) emptyIndividual++ ;
            [durationsQueue addObject: [NSNull null]];
            [beginTimesQueue addObject: [NSNull null]] ;
            continue ;
        }
        
        NSMutableArray* transitionList = [self getTransitionList: config values:realValues from:i to:i+offset+emptyIndividual];
        
        NSMutableArray* newTransitionList = [self applyValuesEasing: config transitionList:transitionList];
        int newTransitionsCount = newTransitionList.count;
        
        float baseTime = isBaseTimeEmpty ? 0.0 : [[times objectAtIndex: i] floatValue];         // a
        
        double offsetUnitTime = isByTotal ? totalTime : stepTime;
        int interval = elementStartingOffset < 0 ? i : (viewsCount - 1 - i - emptyIndividual);
        double intervalTime = interval * (offsetUnitTime * fabsf(elementStartingOffset));       // b
        
        double waitingDuration = baseTime + intervalTime;                                       // c = a + b
        
        double stepDuration = isByTotal ? totalTime : stepTime * (newTransitionsCount-1);       // d
        
        double totalDuration = waitingDuration + stepDuration ;                                 // c + d
        
        float baseRatio = waitingDuration / totalDuration ;
        float stepRatio = stepDuration / totalDuration ;
        
        NSMutableArray* keyTimes = [self getKeyTimes: newTransitionsCount baseRatio:baseRatio stepRatio:stepRatio];
        
        animation.duration = totalDuration;
        animation.values = newTransitionList;
        animation.keyTimes = keyTimes;
        [animation setValue: view forKey:AnimationObject];
        
        [self applyTimingsEasing: config animation:animation];
        
        NSString* animationKey = [NSString stringWithFormat:@"%p_%@",view, animation.keyPath];
        [view.layer addAnimation: animation forKey:animationKey];
        
        [self applyForwardStatus: config animation:animation view:view];
        
        // transfer value to outside
        [beginTimesQueue addObject: [NSNumber numberWithDouble: waitingDuration]];
        [durationsQueue addObject: [NSNumber numberWithDouble: totalDuration]];
    }
}
 

#pragma mark - Private Methods

-(NSMutableArray*) getKeyTimes: (int)count baseRatio:(float)baseRatio stepRatio:(float)stepRatio {
    NSMutableArray* keyTimes = [NSMutableArray array];
    float stepUnitRate = stepRatio / (count-1);
    for (int p = 0; p < count-1; p++) {
        [keyTimes addObject: [NSNumber numberWithFloat: baseRatio + stepUnitRate * p]];
    }
    [keyTimes addObject: [NSNumber numberWithFloat: 1.0]];
    return keyTimes;
}

-(NSMutableArray*) applyValuesEasing: (NSDictionary*)config transitionList:(NSMutableArray*)transitionList {
    NSNumber* degreeNum = [config objectForKey: @"queue.easingDegree"];
    EasingType easeType = [[config objectForKey: @"queue.easingType"] intValue];
    NSKeyframeAnimationFunction easeFunction = [EaseFunction easingFunctionForType: easeType];
    
    int listCount = transitionList.count;
    NSUInteger degree = degreeNum ? ([degreeNum intValue] < listCount-1 ? listCount-1 : [degreeNum intValue]) : listCount-1;
    
    if (! easeFunction) return transitionList;
    
    NSMutableArray* arguments = [NSMutableArray arrayWithCapacity: degree];
    const double increment = 1.0 / (double)(degree - 1);
    double progress = 0.0, argument = 0.0;
    double t = 0 ,b = 0 , c = 1 , d = 1 ;
    
    for (int i = 0; i <= degree; i++) {
        t = (double)i/degree ;
        argument = easeFunction(t, b, c, d) ;
        [arguments addObject: [NSNumber numberWithDouble: argument]];
        progress += increment;
    }
    
    NSMutableArray* newTransitionList = [NSMutableArray array];
    int segments = listCount-1;
    float segmentLength = 1.0 / segments ;
    
    for (NSNumber* number in arguments) {
        double argument = [number doubleValue];
        int where = argument / segmentLength ;
        int nextIndex = (where == segments) ? segments : where+1;
        
        id value = [self getEasingValue: transitionList index:where nextIndex:nextIndex argument:argument];
        
        [newTransitionList addObject: value];
    }
    return newTransitionList;
}

-(NSMutableArray*) getTransitionList: (NSDictionary*)config values:(NSArray*)values from:(int)fromIndex to:(int)toIndex {
    NSMutableArray* transtionList = [NSMutableArray array];
    int transitMode = [[config objectForKey: @"transition.mode"] intValue];
    
    if (values && values.count != 0) {
        
        // roll , default
        if (transitMode == 0) {
            for (int j = fromIndex; j <= toIndex; j++) [transtionList addObject: [values objectAtIndex: j]];
            
            // rain
        } else if(transitMode == 1) {
            [transtionList addObject: [values objectAtIndex: fromIndex]];
            [transtionList addObject: [values objectAtIndex: toIndex]];
            
            // for subclass extending
        } else {
            [self extendTransitionWithMode: transitMode transitionList:transtionList values:values from:fromIndex to:toIndex];
        }
        
    } else {
        [transtionList addObject: [config objectForKey: @"fromValue"]];
        [transtionList addObject:  [config objectForKey: @"toValue"]];
    }
    
    return transtionList.count == 0 ? nil : transtionList;
}

-(void) applyTimingsEasing: (NSDictionary*)config animation:(CAKeyframeAnimation*)animation {
    NSNumber* c1xNum = [config objectForKey: @"queue.timeControl.point1.x"], *c1yNum = [config objectForKey: @"queue.timeControl.point1.y"];
    NSNumber* c2xNum = [config objectForKey: @"queue.timeControl.point2.x"], *c2yNum = [config objectForKey: @"queue.timeControl.point2.y"];
    float c1x = [c1xNum floatValue], c1y = [c1yNum floatValue], c2x = [c2xNum floatValue], c2y = [c2yNum floatValue];
    BOOL isCtrlPoint = c1xNum && c1x >= 0 && c1x <= 1.0 && c1yNum && c1y >=0 && c1y <= 1.0 && c2xNum && c2x >=0 && c2x <= 1.0 && c2yNum && c2y >=0 && c2y <= 1.0 ;
    
    if (isCtrlPoint) {
        NSNumber* controllAll = [config objectForKey: @"queue.timeControl.All"];
        BOOL isControllAll = controllAll ? [controllAll boolValue] : YES;
        BOOL isControllEach = [[config objectForKey: @"queue.timeControl.Each"] boolValue];
        
        if(isControllAll) animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints: c1x :c1y :c2x :c2y];
        
        if (isControllEach) {
            int count = animation.keyTimes.count;
            NSMutableArray* timingFunctions = [NSMutableArray arrayWithCapacity: count];
            for (int i = 0; i < count - 1 ; i++ ) {
                CAMediaTimingFunction* timing = [CAMediaTimingFunction functionWithControlPoints: c1x :c1y :c2x :c2y];
                [timingFunctions addObject: timing];
            }
            animation.timingFunctions = timingFunctions;
        }
    }
}

-(void) applyForwardStatus: (NSDictionary*)config animation:(CAKeyframeAnimation*)animation view:(UIView*)view {
    [self applyForwardWith: [config objectForKey: @"forward"] animation:animation view:view];
}

#pragma mark - Override Methods
-(void) applyKeyPath: (CAKeyframeAnimation*)animation {}

-(NSArray*) translateValues: (NSArray*)values {
    return values;
}


-(void) extendTransitionWithMode: (int)transitionMode transitionList:(NSMutableArray*)transitionList values:(NSArray*)values from:(int)fromIndex to:(int)toIndex {}

-(id) getEasingValue: (NSArray*)values index:(int)index nextIndex:(int)nextIndex argument:(double)argument {
    return nil;
}

-(void) applyForwardWith: (id)forwardNum animation:(CAKeyframeAnimation*)animation view:(UIView*)view {}





#pragma make - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    // deleagate
    if (delegate && [delegate respondsToSelector:@selector(queueDidStart:animation:)]) {
        [delegate queueDidStart: self animation:anim];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // delegate
    if (delegate && [delegate respondsToSelector:@selector(queueDidStop:animation:finished:)]) {
        [delegate queueDidStop: self animation:anim finished:flag];
    }
}

@end
