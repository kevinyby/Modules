#import "StrokeLabel.h"

@implementation StrokeLabel

@synthesize red;
@synthesize green;
@synthesize blue;
@synthesize alpha;
@synthesize width;
@synthesize drawingMode;

@synthesize gradientCount;
@synthesize gradientStartR;
@synthesize gradientStartG;
@synthesize gradientStartB;
@synthesize gradientStartAlpah;
@synthesize gradientEndR;
@synthesize gradientEndG;
@synthesize gradientEndB;
@synthesize gradientEndAlpah;

@synthesize gradientStartPointX;
@synthesize gradientStartPointY;
@synthesize gradientEndPointX;
@synthesize gradientEndPointY;

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
    
    [self gradient: rect context:context];  // gradient the text
}

-(void) gradient: (CGRect)rect context:(CGContextRef)context {
//    CGFloat gradientColors[8] = { 0.5, 0.5, 1.0, 1.0 /* Start color 1.0,1.0,1.0,1.0*/, 1.0, 1.0, 1.0, 0.0 /* End color  1.0, 1.0, 1.0, 0.0*/ };
    CGFloat gradientColors[8] = {gradientStartR, gradientStartG, gradientStartB, gradientStartAlpah, gradientEndR, gradientEndG, gradientEndB, gradientEndAlpah};
    
    // Create a mask from the text
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    
    // clear the image
//    CGContextClearRect(context, rect);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, rect.size.height);
    
    // invert everything because CoreGraphics works with an inverted coordinate system
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Clip the current context to our alphaMask
    CGContextClipToMask(context, rect, alphaMask);
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, gradientColors, NULL, gradientCount);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
//    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGFloat minX = CGRectGetMinX(rect) , maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect) , maxY = CGRectGetMaxY(rect);
    CGPoint startPoint = CGPointMake(minX + (maxX - minX) * gradientStartPointX, minY + (maxY - minY) * gradientStartPointY);
    CGPoint endPoint = CGPointMake(minX + (maxX - minX) * gradientEndPointX, minY + (maxY - minY) * gradientEndPointY);
    
    // Draw the gradient
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    
    // Clean up because ARC doesnt handle CG
    CGImageRelease(alphaMask);
}

@end
