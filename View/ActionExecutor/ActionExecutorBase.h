#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define AnimationObject @"AnimationObject"
#define QueueBaseTimeBegin @"QueueBaseTimeBegin"
#define QueueBaseTimeOver @"QueueBaseTimeOver"

@interface ActionExecutorBase : NSObject {    
    @private
    @protected
}

#pragma mark - Public Properties
@property (strong) id executorDelegate;

#pragma mark - Public Methods
-(void) execute:(NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times ;

#pragma mark - Protected Methods

-(void) initComponent;

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object;

#pragma mark - Private Methods

@end
