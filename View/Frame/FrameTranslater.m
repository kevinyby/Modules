#import "FrameTranslater.h"

#import "UIWiew+CanvasFrame.h"

#import <QuartzCore/QuartzCore.h>

#ifndef LONG
    #define LONG 1024
#endif

#ifndef SHORT
    #define SHORT 768
#endif


@implementation FrameTranslater

static CGSize  portraitCanvasSize;
static CGSize  landscapeCanvasSize;


+ (void)initialize {
    portraitCanvasSize = CGSizeMake(SHORT, LONG);
    landscapeCanvasSize = CGSizeMake(LONG, SHORT);
    [super initialize];
}


#pragma mark -

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

// 
+(void) setRealFrame: (UIInterfaceOrientation)orientation isRotate:(BOOL)isRotate view:(UIView*)view parameters:(NSDictionary*)parameters {
    NSValue* canvasFrameValue = !isRotate ? view.canvasFrame : view.rotateCanvasFrame;
    
    BOOL isPortrait = (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown);
    
    CGRect frame = [self getFrame: isPortrait canvasFrame:[canvasFrameValue CGRectValue] ];
    
    view.frame = frame;
}

+(CGRect)getRotateCanvasFrame: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame {
    CGRect frame = canvasFrame;
    
    CGSize fromCanvas = (isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    CGSize toCanvas = (!isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    
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
+(NSValue*) getFrameValue: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame {
    return [NSValue valueWithCGRect:[self getFrame: isPortrait canvasFrame:canvasFrame]];
}

+(CGRect) getFrame: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame {
    CGRect frame = canvasFrame;
    CGSize canvas = (isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    
    CGSize screen = [FrameTranslater getDeviceRect: isPortrait].size;
    
    float ratioHorizontal = screen.width / canvas.width;
    float ratioVertical = screen.height/ canvas.height;
    
    frame.origin.x *= ratioHorizontal;
    frame.origin.y *= ratioVertical;
    frame.size.width *= ratioHorizontal;
    frame.size.height *= ratioVertical;
    
    return frame;
}

#pragma mark - About Font (In UILable)
+(void) adjustLabelSize: (UILabel*)label orientation:(UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame text:(NSString*)text {
    
    BOOL isPortrait = (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown);
    
    label.frame = canvasFrame;
    label.text = text;
    [self transformLabelSize: label];
    CGRect adjustedFrame  = [self getFrame: isPortrait canvasFrame:canvasFrame ];
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
+ (CGRect) getDeviceRect: (BOOL) isPortrait {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize deviceRectPortrait = screenSize ;
    CGSize deviceRectLandscape = CGSizeMake(screenSize.height, screenSize.width);
    
    CGFloat statusBarOccupied = 0 ;   // forget the status bar influence
//    BOOL _ifHideStatusBar = [UIApplication sharedApplication].statusBarHidden;
//    CGRect deviceStatusBarRect = [[UIApplication sharedApplication] statusBarFrame];
//    statusBarOccupied = (_ifHideStatusBar) ? 0 : isPortrait ? deviceStatusBarRect.size.width : deviceStatusBarRect.size.height;   // for the statusbar
    
    return (isPortrait)
    ? CGRectMake(0, 0 + statusBarOccupied, deviceRectPortrait.width, deviceRectPortrait.height-statusBarOccupied)
    : CGRectMake(0, 0 + statusBarOccupied, deviceRectLandscape.width, deviceRectLandscape.height-statusBarOccupied);
}

@end
