#import "NumberLabel.h"

#define kTimerInterval 0.05f
#define animationDuration (0.5)
#define format @"%01d"

@implementation NumberLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeValues];
    }
    return self;
}

-(void) initializeValues
{
    self.clipsToBounds = NO;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    timer = [NSTimer timerWithTimeInterval: kTimerInterval target:self selector:@selector(increaseText) userInfo:nil repeats:YES];
    isBeing = NO;
}

-(void) startTimer {
    [self setNeedsDisplay];
    if (! isBeing) {
        [[NSRunLoop mainRunLoop] addTimer: timer forMode:NSRunLoopCommonModes];
        isBeing = YES;
    } else {
        [timer setFireDate: [NSDate date]];
    }

}

-(void) increaseText {
    currentScore += increment;
    
    //check if the timer needs to be disabled
    if ((increment >= 0 && currentScore >= newScore) || (increment < 0 && currentScore <= newScore)) {
        currentScore = newScore;
        [timer setFireDate: [NSDate distantFuture]];
    }
    [super setText: [NSString stringWithFormat: format , (int)ceilf(currentScore)]] ;
}


#pragma mark - Overrides
- (void)setText:(NSString *)text {
    if (!text || ([text isKindOfClass:[NSString class]] && [text isEqualToString: @""])) {
        [super setText: nil];
    } else {
        newScore = [text intValue];
        increment = (newScore - currentScore) * kTimerInterval / animationDuration;
        [self startTimer];
    }
}

- (void)dealloc {
    [timer invalidate];
}

@end



