#import <UIKit/UIKit.h>

@interface StrokeLabel : UILabel {
    @private
    @protected
}

#pragma mark - Public Properties 
@property (assign) float red ;
@property (assign) float green ;
@property (assign) float blue ;
@property (assign) float alpha ;
@property (assign) float width ;
@property (assign) int drawingMode ;  // CGTextDrawingMode

@property (assign) int gradientCount;
@property (assign) float gradientStartR;
@property (assign) float gradientStartG;
@property (assign) float gradientStartB;
@property (assign) float gradientStartAlpah;
@property (assign) float gradientEndR;
@property (assign) float gradientEndG;
@property (assign) float gradientEndB;
@property (assign) float gradientEndAlpah;

@property (assign) float gradientStartPointX; // [0,1]
@property (assign) float gradientStartPointY; // [0,1]
@property (assign) float gradientEndPointX;
@property (assign) float gradientEndPointY;

#pragma mark - Public Methods 

#pragma mark - Protected Methods

#pragma mark - Private Methods

@end
