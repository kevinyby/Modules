#import "ActionExecutorManager.h"
#import "ActionExecutorBase.h"

@implementation ActionExecutorManager
{
    NSMutableDictionary* executors;
}

- (id)init {
    self = [super init];
    if (self) {
        executors = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) registerActionExecutor: (NSString*)action executor:(ActionExecutorBase*)executor {
    if (executor) {
        [executors setObject: executor forKey:action];
    }
}

-(void) removeActionExecutor: (NSString*)action {
    [executors removeObjectForKey: action];
}

-(ActionExecutorBase*) getActionExecutor: (NSString*)action {
    return [executors objectForKey: action];
}

-(void) runActionExecutors: (NSArray*)actionsConfigs onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes {
    for (NSInteger i = 0; i < actionsConfigs.count; i++) {
        NSDictionary* config = [actionsConfigs objectAtIndex:i];
        [self runActionExecutor: config onObjects: objects values:values baseTimes:baseTimes];
    }
}

-(void) runActionExecutor: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes {
    if (! objects || objects.count == 0 ) return;
    NSString* action = [config objectForKey: KeyOfAction];
    ActionExecutorBase* executor = [executors objectForKey: action];
    [executor execute: config objects:objects values:values times:baseTimes];
}

@end
