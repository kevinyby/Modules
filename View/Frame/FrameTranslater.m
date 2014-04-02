#import "FrameTranslater.h"

#import <QuartzCore/QuartzCore.h>


// ipad     1024×768        :   1024/768 = 1.333
// iphone   1136×640        :   1136/640 = 1.775
// so we design close to iphone :
// 768 * 1.775 = 1363.2 ---> so canvas is  1363.2x768 , get it to int . then we get 1000 * 1.775 = 1775
// so finally , we get the designed result 1775x1000
// in config and your frame, size, origin, width, height, do notice to use the desiged canvas to measure.

//#define LONG 1775
//#define SHORT 1000

// explain this one designt , 1920/1280=1.5 . but (1.333+1.775)/2=1.555 . ok , there is a little bit contrast
// so , this just bring the average of iphone and ipad's screen resolution
//#define LONG 1920
//#define SHORT 1280



#ifndef LONG
    #define LONG 1024
#endif

#ifndef SHORT
    #define SHORT 768
#endif


@implementation FrameTranslater

static CGSize canvasSize;

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
    canvasSize = CGSizeMake(LONG, SHORT);           // default (landscape)
    
    // For status bar
    isIOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    statusBarVerticalHeight = statusBarSize.height > statusBarSize.width ? statusBarSize.width : statusBarSize.height;
    
    [super initialize];
}


#pragma mark -

+(CGSize) canvasSize
{
    return canvasSize;
}
+(void) setCanvasSize: (CGSize)canvas
{
    canvasSize = canvas;
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

+(CGRect) convertCanvasRect: (CGRect)canvasFrame {
    return [self getFrame: canvasFrame];
}

+(CGSize) convertCanvasSize: (CGSize)size
{
    return [self convertCanvasRect: CGRectMake(0, 0, size.width, size.height)].size;
}

+(CGPoint) convertCanvasPoint: (CGPoint)point
{
    return [self convertCanvasRect: CGRectMake(point.x, point.y, 0, 0)].origin;
}

+(CGFloat) convertCanvasHeight: (CGFloat)y {
    return [self convertCanvasRect: CGRectMake(0, 0, 0, y)].size.height;
}

+(CGFloat) convertCanvasWidth: (CGFloat)x {
    return [self convertCanvasRect: CGRectMake(0, 0, x, 0)].size.width;
}

+(CGFloat) convertCanvasY: (CGFloat)y {
    return [self convertCanvasRect: CGRectMake(0, y, 0, 0)].origin.y;
}

+(CGFloat) convertCanvasX: (CGFloat)x {
    return [self convertCanvasRect: CGRectMake(x, 0, 0, 0)].origin.x;
}


#pragma mark - Ratio

+(float) ratioX
{
    return [[self.screenCanvasRatio firstObject] floatValue];
}

+(float) ratioY
{
    return [[self.screenCanvasRatio lastObject] floatValue];
}

+(NSArray*) screenCanvasRatio {
    return [self getRatios: canvasSize];
}


#pragma mark - Private Methods

+(CGRect) getFrame: (CGRect)canvasFrame {
    float ratioX = self.ratioX;
    float ratioY = self.ratioY;
    
    CGRect frame = canvasFrame;
    
    frame.origin.x *= ratioX;
    frame.origin.y *= ratioY;
    frame.size.width *= ratioX;
    frame.size.height *= ratioY;
    
    return frame;
}

+(NSArray*) getRatios: (CGSize)canvas {
    CGSize screen = [self getDeviceSize: canvas.height > canvas.width];
    
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
