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


static CGRect frameRect_Landscape;


static bool fixXforRotation;
static bool fixYforRotation;
static bool fixWidthforRotation;
static bool fixHeightforRotation;
static bool fixXforDevice;
static bool fixYforDevice;
static bool fixWidthforDevice;
static bool fixHeightforDevice;
static bool maintainRatioByX;
static bool maintainRatioByY;
static bool alignCenterAfterAspectMaintainence;

static bool notShiftPositionToFollowAspectMaintanence;

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
    CGRect canvasFrame = [canvasFrameValue CGRectValue];
    CGRect frame = [self getFrame: orientation canvasFrame:canvasFrame parameters:parameters];
    view.frame = frame;
}

// device
+(CGRect) getFrame: (UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame parameters:(NSDictionary*)parameters {
//    [self setupParameters: parameters];
    
    BOOL isPortrait = (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown);
    
    CGRect frame = canvasFrame;
    CGSize canvas = (isPortrait) ? portraitCanvasSize : landscapeCanvasSize;
    
    CGSize screen = [FrameTranslater getDeviceRect:isPortrait].size;
    
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
    label.frame = canvasFrame;
    label.text = text;
    [self adjustFitSize: label];
    CGRect adjustedFrame  = [self getFrame: orientation canvasFrame:canvasFrame parameters:nil];
    adjustedFrame.size.width = label.frame.size.width; 
    adjustedFrame.size.height = label.frame.size.height;
    label.frame = adjustedFrame;
}



#pragma mark - Private Methods
+(void) adjustFitSize: (UILabel*)label {
    CGRect screenBonus = [[UIScreen mainScreen] bounds];
    
    //    float sx = (float)screenBonus.size.width / (float)SHORT;
    //    float sy = (float)screenBonus.size.height / (float)LONG;
    float sx = (float)screenBonus.size.width / (float)portraitCanvasSize.width;
    float sy = (float)screenBonus.size.height / (float)portraitCanvasSize.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        label.transform = CGAffineTransformMakeScale(sx, sy);
        label.layer.anchorPoint = CGPointMake(1, 1);
    }
}

// ie . ignore the case of statusbar , portrait (768 x 1024) , then landscape (1024 x 768)
+ (CGRect) getDeviceRect: (BOOL) isPortrait {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize deviceRectPortrait = screenSize ;
    CGSize deviceRectLandscape = CGSizeMake(screenSize.height, screenSize.width);
    CGRect deviceStatusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    BOOL _ifHideStatusBar = [UIApplication sharedApplication].statusBarHidden;
    CGFloat adjustmentY = (_ifHideStatusBar) ? 0 : deviceStatusBarRect.size.height;
    
    return (isPortrait)
    ? CGRectMake(0, 0 + adjustmentY, deviceRectPortrait.width, deviceRectPortrait.height-adjustmentY)
    : CGRectMake(0, 0 + adjustmentY, deviceRectLandscape.width, deviceRectLandscape.height-adjustmentY);
    
}

+(void) setupParameters: (NSDictionary*)parameters {        // TODO user enum instead of it .
    fixXforRotation = [[parameters objectForKey: Frame_fixXforRotation] boolValue];
    fixYforRotation = [[parameters objectForKey: Frame_fixYforRotation] boolValue];
    fixWidthforRotation = [[parameters objectForKey: Frame_fixWidthforRotation] boolValue];
    fixHeightforRotation = [[parameters objectForKey: Frame_fixHeightforRotation] boolValue];
    
    fixXforDevice = [[parameters objectForKey: Frame_fixXforDevice] boolValue];
    fixYforDevice = [[parameters objectForKey: Frame_fixYforDevice] boolValue];
    fixWidthforDevice = [[parameters objectForKey: Frame_fixWidthforDevice] boolValue];
    fixHeightforDevice = [[parameters objectForKey: Frame_fixHeightforDevice] boolValue];
    
    maintainRatioByX = [[parameters objectForKey: Frame_maintainRatioByX] boolValue];
    maintainRatioByY = [[parameters objectForKey: Frame_maintainRatioByY] boolValue];
    alignCenterAfterAspectMaintainence = [[parameters objectForKey: Frame_alignCenterAfterAspectMaintainence] boolValue];
    notShiftPositionToFollowAspectMaintanence = [[parameters objectForKey: Frame_notShiftPositionToFollowAspectMaintanence] boolValue];
}

@end
