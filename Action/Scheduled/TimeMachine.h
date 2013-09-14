#import <Foundation/Foundation.h>

@class CharacterQueue;

@interface TimeMachine : NSObject {    
    @private
    BOOL begining;
    int timeElapsedCount;
    NSMutableSet* singleEventList;
    NSMutableDictionary* repeatEventList;
    
    @protected
}

#pragma mark - Public Properties
@property(strong) NSTimer* worldTimer;
@property(assign) float timeInterval;

#pragma mark - Public Methods 
-(id) initWithInterval: (CGFloat)interval ;

-(void) registerRepeatEvent: (id)target action:(SEL)action tick:(int)tick;
-(void) registerSingleEvent: (id)target action:(SEL)action afterDelay:(NSTimeInterval)duration;
-(void) cancleRepeatTarget: (id)target action:(SEL)action ;
-(void) cancleSingleTarget: (id)target action:(SEL)action ;
-(void) cancleAllEvents ;

-(void) begin;
-(void) resume;
-(void) pause;
-(void) stop;

#pragma mark - Protected Methods

#pragma mark - Private Methods


@end
