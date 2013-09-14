#import <Foundation/Foundation.h>

@interface QueueExecutorHelper : NSObject

+(void) processNeedReturnValueConfig: (NSDictionary*)config ;

+(NSMutableArray*) getReturnValueInnerArray: (int)index array:(NSMutableArray*)array ;
+(double) getQueuesBeginTime: (NSDictionary*)config ;
+(double) getQueuesDuration: (NSDictionary*)config ;
+(NSNumber*) getExtremeValue: (NSArray*)numbers isMax:(BOOL)isMax ;


@end
