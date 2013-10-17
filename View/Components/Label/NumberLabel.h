#import <UIKit/UIKit.h>

#import "StrokeLabel.h"

@interface NumberLabel : StrokeLabel {
    @private
    NSTimer* timer;
    NSInteger newScore;
    float currentScore;
    float increment;
    
    BOOL isBeing;
    @protected
}

#pragma mark - Public Properties 

#pragma mark - Public Methods 

#pragma mark - Protected Methods

#pragma mark - Private Methods

@end
