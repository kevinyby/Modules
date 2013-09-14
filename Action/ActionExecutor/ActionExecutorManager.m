#import "ActionExecutorManager.h"
#import "ActionExecutorBase.h"

@implementation ActionExecutorManager

- (id)init {
    self = [super init];
    if (self) {
        executors = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) registerActionExecutor: (NSString*)action executor:(ActionExecutorBase*)executor delegate:(id)executorDelegate {
    if (executorDelegate) {
    	executor.executorDelegate = executorDelegate;
    }
    if (executor) {
        [executors setObject: executor forKey:action];
    }
}

-(void) cancelActionExecutor: (NSString*)action {
    [executors removeObjectForKey: action];
}

-(ActionExecutorBase*) getActionExecutor: (NSString*)action {
    return [executors objectForKey: action];
}

-(void) runActionExecutors: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes {
    for (NSString* key in config) {
        NSDictionary* actionParameters = [config objectForKey: key];
        [self runActionExecutor: actionParameters onObjects: objects values:values baseTimes:baseTimes];
    }
}

-(void) runActionExecutor: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes {
    if (! objects || objects.count == 0 ) return;
    NSString* action = [config objectForKey: KeyOfAction];
    ActionExecutorBase* executor = [executors objectForKey: action];
    [executor execute: config objects:objects values:values times:baseTimes];
}

@end
