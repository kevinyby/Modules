#import "QueueExecutorHelper.h"
#import "ActionExecutorBase.h"

@implementation QueueExecutorHelper

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
