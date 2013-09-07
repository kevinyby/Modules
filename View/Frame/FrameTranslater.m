#import "FrameTranslater.h"

#import <QuartzCore/QuartzCore.h>

#ifndef LONG
    #define LONG 1024
#endif

#ifndef SHORT
    #define SHORT 768
#endif


@implementation FrameTranslater


static bool isPortraitDesigned;

static CGSize  portraitCanvasSize;
static CGSize  landscapeCanvasSize;



static bool isStatusBarHidden;
static CGFloat statusBarVerHeight;


+ (void)initialize {
    isPortraitDesigned = YES;                       // default is designed according portrait
    portraitCanvasSize = CGSizeMake(SHORT, LONG);   // default
    landscapeCanvasSize = CGSizeMake(LONG, SHORT);  // default
    
    // For status bar
    isStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    BOOL _isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    statusBarVerHeight = _isPortrait ? statusBarSize.height : statusBarSize.width;
    
    [super initialize];
}


#pragma mark -
+(BOOL) isPortraitDesigned {
    return isPortraitDesigned;
}

+(void) setIsPortraitDesigned: (BOOL)portraitDesigned {
    isPortraitDesigned = portraitDesigned;
}

+(CGSize) getPortraitCanvasSize {
    return portraitCanvasSize;
}

+(CGSize) setLandscapeCanvasSize {
    return landscapeCanvasSize ;
}

+(void) setPortraitCanvasSize: (CGSize)size {
    portraitCanvasSize = size;
}

+(void) setLandscapeCanvasSize: (CGSize)size {
    landscapeCanvasSize = size;
}

#pragma mark - About Frame
+(CGRect)getRotateCanvasFrame: (CGRect)canvasFrame {
    return [self getRotateCanvasFrame: isPortraitDesigned canvasFrame:canvasFrame];
}
+(CGRect)getRotateCanvasFrame: (BOOL)isInitPortrait canvasFrame:(CGRect)canvasFrame {
    CGRect frame = canvasFrame;
    
    CGSize fromCanvas = (isInitPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    CGSize toCanvas = (!isInitPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    
    float ratioHorizontal = toCanvas.width / fromCanvas.width;
    float ratioVertical = toCanvas.height/ fromCanvas.height;
    
    frame.origin.x *= ratioHorizontal;
    frame.origin.y *= ratioVertical;
    
    float targetWidth = frame.size.width * ratioHorizontal;
    float targetHeight = frame.size.height * ratioVertical;
    
    float minusWidth = targetWidth - frame.size.width ;
    float minusHeight = targetHeight - frame.size.height ;
    
    frame.origin.x += minusWidth/2;
    frame.origin.y += minusHeight/2;
    
    return frame;
    
}


// device
+(CGRect) getFrame: (CGRect)canvasFrame {
    return [self getFrame: isPortraitDesigned canvasFrame:canvasFrame];
}
+(CGRect) getFrame: (BOOL)isInitPortrait canvasFrame:(CGRect)canvasFrame {
    CGRect frame = canvasFrame;
    CGSize canvas = (isInitPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    
    CGSize screen = [FrameTranslater getDeviceRect: isInitPortrait].size;
    
    float ratioHorizontal = screen.width / canvas.width;
    float ratioVertical = screen.height/ canvas.height;
    
    frame.origin.x *= ratioHorizontal;
    frame.origin.y *= ratioVertical;
    frame.size.width *= ratioHorizontal;
    frame.size.height *= ratioVertical;
    
    return frame;
}

#pragma mark - About Font (In UILable)
+(void) adjustLabelSize: (UILabel*)label canvasFrame:(CGRect)canvasFrame text:(NSString*)text {
    return [self adjustLabelSize: label isInitPortrait:isPortraitDesigned canvasFrame:canvasFrame text:text];
}
+(void) adjustLabelSize: (UILabel*)label isInitPortrait:(BOOL)isInitPortrait canvasFrame:(CGRect)canvasFrame text:(NSString*)text {
    label.frame = canvasFrame;
    label.text = text;
    [self transformLabelSize: label];
    CGRect adjustedFrame  = [self getFrame: isInitPortrait canvasFrame:canvasFrame ];
    adjustedFrame.size.width = label.frame.size.width; 
    adjustedFrame.size.height = label.frame.size.height;
    label.frame = adjustedFrame;
}

+(void) transformLabelSize: (UILabel*)label {
    CGRect screenBonus = [[UIScreen mainScreen] bounds];
    
    float sx = (float)screenBonus.size.width / (float)portraitCanvasSize.width;
    float sy = (float)screenBonus.size.height / (float)portraitCanvasSize.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        label.transform = CGAffineTransformMakeScale(sx, sy);
        label.layer.anchorPoint = CGPointMake(1, 1);
    }
}


#pragma mark - Private Methods

// ie . ignore the case of statusbar , portrait (768 x 1024) , then landscape (1024 x 768)
+ (CGRect) getDeviceRect: (BOOL) isInitPortrait {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize deviceRectPortrait = screenSize ;
    CGSize deviceRectLandscape = CGSizeMake(screenSize.height, screenSize.width);
    
    CGFloat statusBarOccupied = 0 ;   // forget the status bar influence
    statusBarOccupied = (isStatusBarHidden) ? 0 : statusBarVerHeight;   // for the statusbar influence
    
    return (isInitPortrait)
    ? CGRectMake(0, 0 + statusBarOccupied, deviceRectPortrait.width, deviceRectPortrait.height-statusBarOccupied)
    : CGRectMake(0, 0 + statusBarOccupied, deviceRectLandscape.width, deviceRectLandscape.height-statusBarOccupied);
}

@end
