#import <Foundation/Foundation.h>

#define KeyOfAction @"action"

@class ActionExecutorBase;

@interface ActionExecutorManager : NSObject

#pragma mark - Public Properties

#pragma mark - Public Methods 
-(void) registerActionExecutor: (NSString*)action executor:(ActionExecutorBase*)executor ;

-(void) removeActionExecutor: (NSString*)action ;
-(ActionExecutorBase*) getActionExecutor: (NSString*)action ;

-(void) runActionExecutors: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes ;

-(void) runActionExecutor: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes ;

#pragma mark - Protected Methods

#pragma mark - Private Methods

@end
