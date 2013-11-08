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


/**
 Note here :
 
    all "canvasFrame" is the designed canvas frame , the origin frame on your canvas 
 
    not the value has been fixed by device frame .
 
    not the property of UIView+CanvasFrame .
 
 **/

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

+(CGSize) getLandscapeCanvasSize {
    return landscapeCanvasSize ;
}

+(void) setPortraitCanvasSize: (CGSize)size {
    portraitCanvasSize = size;
}

+(void) setLandscapeCanvasSize: (CGSize)size {
    landscapeCanvasSize = size;
}


// device
+(CGRect) getFrame: (CGRect)canvasFrame {
    return [self getFrame: isPortraitDesigned canvasFrame:canvasFrame];
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
/**
 Example:
 NSLog(@"%@", [UIFont familyNames]);
 UILabel* helloworld = [[UILabel alloc] init];
 helloworld.layer.borderColor = [[UIColor greenColor] CGColor];
 helloworld.layer.borderWidth = 1.0f;
 helloworld.text = @"Hello world";
 helloworld.font = [UIFont fontWithName:@"Bradley Hand" size:40];
 CGRect rect = CGRectMake(200, 300, 200, 50);
 [FrameHelper translateCanvas: rect view:helloworld];
 helloworld.frame = [helloworld.canvasFrame CGRectValue];
 [self.view addSubview: helloworld];
 
 [FrameTranslater adjustLabelSize: helloworld canvasFrame:rect]; // pass rect , not [helloworld.canvasFrame CGRectValue]
 **/
+(void) adjustLabelSize: (UILabel*)label canvasFrame:(CGRect)canvasFrame {
    return [self adjustLabelSize: label isPortrait:isPortraitDesigned canvasFrame:canvasFrame ];
}
+(void) adjustLabelSize: (UILabel*)label isPortrait:(BOOL)isPortrait canvasFrame:(CGRect)canvasFrame { 
    [self transformLabelSize: label isPortrait:isPortrait];
    CGRect adjustedFrame  = [self getFrame: isPortrait canvasFrame:canvasFrame ];
    label.frame = adjustedFrame;
}

+(void) transformLabelSize: (UILabel*)label isPortrait:(BOOL)isPortrait {
    CGRect screenBonus = [self getDeviceRect: isPortrait] ;

    CGSize canvas = (isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    float sx = (float)screenBonus.size.width / (float)canvas.width;
    float sy = (float)screenBonus.size.height / (float)canvas.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        label.transform = CGAffineTransformMakeScale(sx, sy);
        label.layer.anchorPoint = CGPointMake(1, 1);
    }
}

#pragma mark - 
+(CGFloat) translateFontSize: (CGFloat)fontSize {
    CGRect screenBonus = [self getDeviceRect: isPortraitDesigned] ;
    CGSize canvas = (isPortraitDesigned) ? portraitCanvasSize : landscapeCanvasSize;
    
    float sx = (float)screenBonus.size.width / (float)canvas.width;
    float sy = (float)screenBonus.size.height / (float)canvas.height;
    
    return fontSize * ((sx+sy)/2);
}

+(CGFloat) canvasScreenRatioX {
    CGRect screenBonus = [self getDeviceRect: isPortraitDesigned] ;
    CGSize canvas = (isPortraitDesigned) ? portraitCanvasSize : landscapeCanvasSize;
    return (float)screenBonus.size.width / (float)canvas.width;
}

+(CGFloat) canvasScreenRatioY {
    CGRect screenBonus = [self getDeviceRect: isPortraitDesigned] ;
    CGSize canvas = (isPortraitDesigned) ? portraitCanvasSize : landscapeCanvasSize;
    return (float)screenBonus.size.height / (float)canvas.height;
}

+(CGFloat) convertCanvasHeight: (CGFloat)y {
    CGRect rect = [self getFrame: CGRectMake(0, 0, 0, y)];
    return rect.size.height;
}

+(CGFloat) convertCanvasWidth: (CGFloat)x {
    CGRect rect = [self getFrame: CGRectMake(0, 0, x, 0)];
    return rect.size.width;
}

+(CGFloat) convertCanvasY: (CGFloat)y {
    CGRect rect = [self getFrame: CGRectMake(0, y, 0, 0)];
    return rect.origin.y;
}

+(CGFloat) convertCanvasX: (CGFloat)x {
    CGRect rect = [self getFrame: CGRectMake(x, 0, 0, 0)];
    return rect.origin.x;
}


#pragma mark - Private Methods

// ie . ignore the case of statusbar , portrait (768 x 1024) , then landscape (1024 x 768)
+ (CGRect) getDeviceRect: (BOOL)isPortrait {

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize deviceRectPortrait = screenSize ;
    CGSize deviceRectLandscape = CGSizeMake(screenSize.height, screenSize.width);
    
    CGFloat statusBarOccupied = 0 ;   // forget the status bar influence
    statusBarOccupied = (isStatusBarHidden) ? 0 : statusBarVerHeight;   // for the statusbar influence
    
    return isPortrait // UIInterfaceOrientationIsPortrait(interfaceOrientation)
    ? CGRectMake(0, 0 + statusBarOccupied, deviceRectPortrait.width, deviceRectPortrait.height-statusBarOccupied)
    : CGRectMake(0, 0 + statusBarOccupied, deviceRectLandscape.width, deviceRectLandscape.height-statusBarOccupied);
}

@end
