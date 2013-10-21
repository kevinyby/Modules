#import "StrokeLabel.h"

@implementation StrokeLabel

@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;
@synthesize width;
@synthesize drawingMode;

- (void)drawTextInRect:(CGRect)rect {
    self.adjustsFontSizeToFitWidth = YES;
    CGSize shadowOffset = self.shadowOffset;
    UIColor* textColor = self.textColor;
    
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(context, drawingMode);  // default kCGTextStroke
    self.textColor = [UIColor colorWithRed: red green:green blue:blue alpha:alpha];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
//    [self gradient: rect context:context];  // gradient the text  // Test the context in subclass
}

@end
