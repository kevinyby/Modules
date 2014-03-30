#import "TrackExecutor.h"
#import "EaseFunction.h"

#define defaultStepTime 0.05

@implementation TrackExecutor

-(void) applyKeyPath: (CAKeyframeAnimation*)animation {
    animation.keyPath = @"position";
}

-(NSArray*) translateValues: (NSArray*)values {
    BOOL isCGPoint = strcmp(@encode(CGPoint), [[values lastObject] objCType]) == 0;
    return isCGPoint ? values : [self translateRectValueToPointValue: values];
}

-(id) getEasingValue: (NSArray*)values index:(int)index nextIndex:(int)nextIndex argument:(double)argument {
    CGPoint currentPoint = [[values objectAtIndex: index] CGPointValue];
    CGPoint nextPoint = [[values objectAtIndex: nextIndex] CGPointValue];
    
    double positionX = currentPoint.x + (nextPoint.x - currentPoint.x) * argument;
    double positionY = currentPoint.y + (nextPoint.y - currentPoint.y) * argument;
    return [NSValue valueWithCGPoint: CGPointMake(positionX, positionY)];
}

-(void) applyForwardWith: (id)forwardNum animation:(CAKeyframeAnimation*)animation view:(UIView*)view {
    BOOL isForward = forwardNum ? [forwardNum boolValue] : YES;           // application default is YES
    if (isForward) view.center = [[animation.values lastObject] CGPointValue];
}

-(void) extendTransitionWithMode: (int)transitionMode transitionList:(NSMutableArray*)transitionList values:(NSArray*)values from:(int)fromIndex to:(int)toIndex{
    // skip
    if (transitionMode == 2) {
        NSMutableArray* tempList = [NSMutableArray array];
        for (int j = fromIndex; j <= toIndex; j++) [tempList addObject: [values objectAtIndex: j]];
        NSMutableArray* newTransitionList = [self leavingTheTurningPoint: tempList];
        [transitionList setArray: newTransitionList];
    }
}

#pragma mark - Private Methods
-(NSMutableArray*) translateRectValueToPointValue: (NSArray*)values {
    NSInteger count = values.count;
    NSMutableArray* pointValues = [NSMutableArray arrayWithCapacity: values.count];
    for (int i = 0; i < count; i ++) {
        NSValue* rectValue = [values objectAtIndex: i];
        NSValue* pointValue = [self getCenterFromRect: rectValue];
        [pointValues addObject: pointValue];
    }
    return pointValues;
}

-(NSValue*) getCenterFromRect: (NSValue*)rectValue {
    CGRect rect = [rectValue CGRectValue];
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    return [NSValue valueWithCGPoint: center];
}

-(NSMutableArray*) leavingTheTurningPoint: (NSMutableArray*)transtionList {
    float preRadians = 3.15;
    NSInteger count = transtionList.count;
    NSMutableArray* newTransition = [NSMutableArray arrayWithCapacity: 2];
    for (int i = 0; i < count-1; i++) {
        NSValue* value = [transtionList objectAtIndex: i] ;
        CGPoint point = [value CGPointValue];
        NSValue* nextValue = [transtionList objectAtIndex: i+1];
        CGPoint nextPoint = [nextValue CGPointValue] ;
        
        if (value == nextValue || CGPointEqualToPoint(point, nextPoint)) {
            [newTransition addObject: value];
        } else {
            float radians = [self getRadianBetween: point to:nextPoint];
            if (preRadians != radians) {
                [newTransition addObject: value];
                preRadians = radians;
            }
        }
    }
    [newTransition addObject: [transtionList lastObject]];
    return newTransition;
}

-(float) getRadianBetween:(CGPoint)p1 to:(CGPoint)p2 {
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    float radains = atan2f(dx , dy);
    return radains;
}

@end
