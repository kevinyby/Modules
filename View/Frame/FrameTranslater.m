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

static bool isIOS7;
static CGFloat statusBarVerticalHeight;


/** Note here : All "canvasFrame" here is the designed frame **/

/** 
 
 Note here: 
    For the status Bar, 1 for portrait , 0 for landscape (Heigth in ipad,iphone = 20)
 
     willRotate: controller.view {768, 1024} , 1; statusBaris {768, 20},  1
     
     didRotate:  controller.view {1024, 768} , 0; statusBaris {20, 1024}, 0
     
     But for ios 7 , the status bar does influence the controller.view
 
 **/

+ (void)initialize {
    isPortraitDesigned = YES;                       // default is designed according portrait
    portraitCanvasSize = CGSizeMake(SHORT, LONG);   // default
    landscapeCanvasSize = CGSizeMake(LONG, SHORT);  // default
    
    // For status bar
    isIOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
//    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
//    statusBarVerticalHeight = isPortrait ? statusBarSize.height : statusBarSize.width;
    statusBarVerticalHeight = statusBarSize.height > statusBarSize.width ? statusBarSize.width : statusBarSize.height;
    
    [super initialize];
}


#pragma mark -
+(BOOL) isPortraitDesigned {
    return isPortraitDesigned;
}
+(void) setIsPortraitDesigned: (BOOL)isPortrait {
    isPortraitDesigned = isPortrait;
}

+(CGSize) portraitCanvasSize {
    return portraitCanvasSize;
}
+(void) setPortraitCanvasSize: (CGSize)size {
    portraitCanvasSize = size;
}

+(CGSize) landscapeCanvasSize {
    return landscapeCanvasSize ;
}
+(void) setLandscapeCanvasSize: (CGSize)size {
    landscapeCanvasSize = size;
}

#pragma mark - About Font (In UILable)
// transform label , then getFrame
+(void) transformView: (UIView*)view
{
    float ratioX = self.ratioX;
    float ratioY = self.ratioY;
    if (ratioX == 1.0 && ratioY == 1.0) {
        view.transform = CGAffineTransformIdentity;
    } else {
        view.transform = CGAffineTransformMakeScale(ratioX, ratioY);
    }
}

// convert size for label(then getFrame), textfield ...
+(CGFloat) convertFontSize: (CGFloat)fontSize {
    float ratioX = self.ratioX;
    float ratioY = self.ratioY;
    return fontSize * ((ratioX + ratioY) / 2);
}


#pragma mark -

+(CGRect) convertFrame: (CGRect)canvasFrame {
    return [self getFrame: isPortraitDesigned canvasFrame:canvasFrame];
}

+(CGSize) convertCanvasSize: (CGSize)size
{
    return [self convertFrame: CGRectMake(0, 0, size.width, size.height)].size;
}

+(CGPoint) convertCanvasPoint: (CGPoint)point
{
    return [self convertFrame: CGRectMake(point.x, point.y, 0, 0)].origin;
}

+(CGFloat) convertCanvasHeight: (CGFloat)y {
    return [self convertFrame: CGRectMake(0, 0, 0, y)].size.height;
}

+(CGFloat) convertCanvasWidth: (CGFloat)x {
    return [self convertFrame: CGRectMake(0, 0, x, 0)].size.width;
}

+(CGFloat) convertCanvasY: (CGFloat)y {
    return [self convertFrame: CGRectMake(0, y, 0, 0)].origin.y;
}

+(CGFloat) convertCanvasX: (CGFloat)x {
    return [self convertFrame: CGRectMake(x, 0, 0, 0)].origin.x;
}


#pragma mark -

+(float) ratioX
{
    return [[self.screenCanvasRatio firstObject] floatValue];
}

+(float) ratioY
{
    return [[self.screenCanvasRatio lastObject] floatValue];
}

+(NSArray*) screenCanvasRatio {
    return [self getRatios: isPortraitDesigned];
}


#pragma mark - Private Methods

+(CGRect) getFrame: (BOOL)isPortrait canvasFrame:(CGRect)canvasFrame {
    float ratioX = self.ratioX;
    float ratioY = self.ratioY;
    
    CGRect frame = canvasFrame;
    
    frame.origin.x *= ratioX;
    frame.origin.y *= ratioY;
    frame.size.width *= ratioX;
    frame.size.height *= ratioY;
    
    return frame;
}

+(NSArray*) getRatios:(BOOL)isPortrait {
    CGSize canvas = (isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    CGSize screen = [self getDeviceSize: isPortrait];
    
    float ratioX = (float)screen.width / (float)canvas.width;
    float ratioY = (float)screen.height/ (float)canvas.height;
    return @[[NSNumber numberWithFloat: ratioX], [NSNumber numberWithFloat: ratioY]];
}

+ (CGSize) getDeviceSize: (BOOL)isPortrait
{
    // like UIWindow's bounds,  always will be (768 x 1024)(ipad) not influnce by orientation.
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    // Ignore the case of statusbar on ios 7 and hidden.
    CGFloat statusBarVH = isIOS7 || [UIApplication sharedApplication].statusBarHidden ? 0 : statusBarVerticalHeight;
    
    return isPortrait ? CGSizeMake(screenSize.width, screenSize.height-statusBarVH):
                        CGSizeMake(screenSize.height, screenSize.width-statusBarVH);
}


@end
