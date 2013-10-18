#import "QueueExecutorHelper.h"
#import "ActionExecutorBase.h"

@implementation QueueExecutorHelper

# pragma mark - For Return Value
+(void) processNeedReturnValueConfig: (NSDictionary*)config {
    if ([config isKindOfClass: [NSMutableDictionary class]]) {
        NSMutableArray* beginTimes = [config objectForKey: QueueBaseTimeBegin];
        NSMutableArray* durations = [config objectForKey: QueueBaseTimeOver];
        if (! (beginTimes && durations) ) {
            @try {
                [(NSMutableDictionary*)config setObject: [NSMutableArray array] forKey:QueueBaseTimeBegin];
                [(NSMutableDictionary*)config setObject: [NSMutableArray array] forKey:QueueBaseTimeOver];
            }
            @catch (NSException *exception) {
                // in ios 5.0 , even though the config is a member of nsdictionary, it will run into here.
            }
        }
        [self clearReturnValueElements: beginTimes];
        [self clearReturnValueElements: durations];
    }
}

+(void) clearReturnValueElements: (NSMutableArray*)array {
    BOOL isMatrix = [[array lastObject] isKindOfClass: [NSArray class]];
    if (isMatrix) {
        for (int i = 0; i < array.count; i++) {
            NSMutableArray* innerArray = [array objectAtIndex: i];
            [innerArray removeAllObjects];
        }
    } else {
        [array removeAllObjects];
    }
}

+(NSMutableArray*) getReturnValueInnerArray: (int)index array:(NSMutableArray*)array {
    NSMutableArray* innerArray = nil;
    if (array.count > index) {
        innerArray = [array objectAtIndex: index];
    } else {
        innerArray = [NSMutableArray arrayWithCapacity:1];
        [array addObject: innerArray];
    }
    [innerArray removeAllObjects];
    return innerArray;
}

+(double) getQueuesBeginTime: (NSDictionary*)config {
    NSMutableArray* beginTimes = [config objectForKey: QueueBaseTimeBegin];
    NSNumber* minTimeNum = [self getExtremeValue: beginTimes isMax:NO];
    return [minTimeNum doubleValue];
}

+(double) getQueuesDuration: (NSDictionary*)config {
    NSMutableArray* durations = [config objectForKey: QueueBaseTimeOver];
    NSNumber* maxDurationNum = [self getExtremeValue: durations isMax:YES];
    return [maxDurationNum doubleValue];
}

+(NSNumber*) getExtremeValue: (NSArray*)numbers isMax:(BOOL)isMax {
    NSObject* object = [numbers lastObject];
    NSNumber* value = nil;;
    
    // two dimensional
    if ([object isKindOfClass: [NSArray class]]) {
        for (int i = 0; i < numbers.count; i++) {
            NSMutableArray* innerArray = [numbers objectAtIndex: i];
            for (int j = 0; j < innerArray.count; j++) {
                NSNumber* element = [innerArray objectAtIndex: j];
                if ([element isKindOfClass:[NSNull class]]) continue;
                double elementValue = [element doubleValue];
                //                if (elementValue < 0) continue ;
                if (! value) value = element;
                
                if (isMax && [value doubleValue] < elementValue) {
                    value = element ;
                }
                
                if (! isMax && [value doubleValue] > elementValue) {
                    value = element;
                }
            }
        }
        
    // one dimensional
    } else {
        for (int j = 0; j < numbers.count; j++) {
            NSNumber* element = [numbers objectAtIndex: j];
            if ([element isKindOfClass:[NSNull class]]) continue;
            double elementValue = [element doubleValue];
            //            if (elementValue < 0) continue ;
            if (! value) value = element;
            
            if (isMax && [value doubleValue] < elementValue) {
                value = element ;
            }
            
            if (! isMax && [value doubleValue] > elementValue) {
                value = element;
            }
        }
    }
    
    return [NSNumber numberWithDouble: [value doubleValue]];
}

@end
