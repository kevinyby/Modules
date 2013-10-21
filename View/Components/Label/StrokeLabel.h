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

#pragma mark - Public Methods 

#pragma mark - Protected Methods

#pragma mark - Private Methods

@end
