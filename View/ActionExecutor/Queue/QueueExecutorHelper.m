#import "QueueExecutorHelper.h"
#import "ActionExecutorBase.h"

@implementation QueueExecutorHelper

+(NSNumber*) getExtremeValue: (NSArray*)numbers isMax:(BOOL)isMax
{
    NSArray* compares = numbers;
    
    // two dimensional
    NSObject* object = [numbers firstObject];
    if ([object isKindOfClass: [NSArray class]]) {
        NSMutableArray* oneDimension = [NSMutableArray array];
        for (int i = 0; i < numbers.count; i++) {
            NSMutableArray* innerArray = [numbers objectAtIndex: i];
            NSNumber* element = [self getExtremeValueFromOneDimensionArray: innerArray isMax:isMax];
            if (element) [oneDimension addObject: element];
        }
        compares = oneDimension;
    }
    
    return [self getExtremeValueFromOneDimensionArray: compares isMax:isMax];
}

+(NSNumber*) getExtremeValueFromOneDimensionArray:(NSArray*)numbers isMax:(BOOL)isMax
{
    NSNumber* value = nil;
    for (int j = 0; j < numbers.count; j++) {
        NSNumber* element = [numbers objectAtIndex: j];
        if ([element isKindOfClass:[NSNull class]]) continue;
        double elementValue = [element doubleValue];
        
        if (! value) value = element;
        
        // get max
        if (isMax && [value doubleValue] < elementValue) {
            value = element ;
        }
        
        else
        
        // get min
        if (! isMax && [value doubleValue] > elementValue) {
            value = element;
        }
    }
    return value;
}

@end
