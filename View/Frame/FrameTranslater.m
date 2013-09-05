#import "FrameTranslater.h"

#import <QuartzCore/QuartzCore.h>

@implementation FrameTranslater


static CGSize  portraitCanvasRect;
static CGSize  landscapeCanvasRect;

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


#pragma mark -

+(void) setPortraitCanvasRect: (CGSize)size {
    portraitCanvasRect = size;
}

+(void) setLandscapeCanvasRect: (CGSize)size {
    landscapeCanvasRect = size;
}

#pragma mark - About Frame

+(CGRect) getFrame: (UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame parameters:(NSDictionary*)parameters {
    [self setupParameters: parameters];
    
    BOOL isPortrait = (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown);
    
    BOOL ifAdoptTheOtherOrientataion = ((isPortrait && CGRectIsNull(canvasFrame)) || ((!isPortrait) && CGRectIsNull(frameRect_Landscape)));
    
    CGRect frame = canvasFrame;
    CGSize canvas = portraitCanvasRect;
    
    if (! isPortrait || CGRectIsNull(canvasFrame)) {
        if (! CGRectIsNull(frameRect_Landscape)){
            frame = frameRect_Landscape;
            canvas = landscapeCanvasRect;
        }
        // else Assertion wrong
    }
    
    //    if (frame.origin.x < (CGFloat) 0) frame.origin.x += canvas.width;
    //    if (frame.origin.y < (CGFloat) 0) frame.origin.y += canvas.height;
    
    //Rotation Adjustment
    if (ifAdoptTheOtherOrientataion) {
        CGSize canvasTarget = (isPortrait)  ? portraitCanvasRect : landscapeCanvasRect;
        
        float ratioHorizontal = canvasTarget.width / canvas.width;
        float ratioVertical = canvasTarget.height/ canvas.height;
        
        if (maintainRatioByX) ratioVertical = ratioHorizontal;
        if (maintainRatioByY) ratioHorizontal = ratioVertical;
        
        if (!fixXforRotation) frame.origin.x *= ratioHorizontal;
        if (!fixYforRotation) frame.origin.y *= ratioVertical;
        if (!fixWidthforRotation) frame.size.width *= ratioHorizontal;
        if (!fixHeightforRotation) frame.size.height *= ratioVertical;
        
        canvas = canvasTarget;
    }
    
    CGSize screen =[FrameTranslater getDeviceRect:orientation].size;
    
    float ratioHorizontal = screen.width / canvas.width;
    float ratioVertical = screen.height/ canvas.height;
    
    if (!fixXforDevice) {
        if (maintainRatioByY) {
            if (!notShiftPositionToFollowAspectMaintanence) {
                frame.origin.x *= ratioVertical;
            }else {
                frame.origin.x *= ratioHorizontal;
                
                if (alignCenterAfterAspectMaintainence) {
                    frame.origin.x += frame.size.width * (ratioHorizontal - ratioVertical) / 2;
                }
            }
            
            ratioHorizontal = ratioVertical;
        }else {
            frame.origin.x *= ratioHorizontal;
        }
    }
    
    if (!fixYforDevice) {
        if (maintainRatioByX) {
            if (!notShiftPositionToFollowAspectMaintanence) {
                frame.origin.y *= ratioHorizontal;
            }else {
                frame.origin.y *= ratioVertical;
                
                if (alignCenterAfterAspectMaintainence) {
                    frame.origin.y += frame.size.height* (ratioVertical - ratioHorizontal) / 2;
                }
            }
            
            ratioVertical = ratioHorizontal;
        }else {
            frame.origin.y *= ratioVertical;
        }
    }
    
    if (!fixWidthforDevice) frame.size.width *= ratioHorizontal;
    if (!fixHeightforDevice) frame.size.height *= ratioVertical;
    
    return frame;
}

+(CGRect) convertFrame: (CGRect)canvasFrame orientation:(UIInterfaceOrientation)orientation {
    CGRect rect = CGRectNull;
    
    switch ((int)orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            rect = [self getFrame: orientation canvasFrame:canvasFrame parameters:nil];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            frameRect_Landscape = canvasFrame;
            rect = [self getFrame: orientation canvasFrame:canvasFrame parameters:nil];
            break;
    }
    return rect;
}

+ (CGRect) getDeviceRect: (UIInterfaceOrientation) orientation {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow* appWindow = [appDelegate valueForKey: @"window"];             // Hard Code Here
    
    CGSize deviceRectPortrait = [appWindow bounds].size;
    CGSize deviceRectLandscape = CGSizeMake([appWindow bounds].size.height, [appWindow bounds].size.width);
    CGRect deviceStatusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    BOOL _isPortrait = (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown);
    
    BOOL _ifHideStatusBase = [UIApplication sharedApplication].statusBarHidden;
    CGFloat adjustmentY = (_ifHideStatusBase) ? 0 : deviceStatusBarRect.size.height;
    
    return (_isPortrait)
    ? CGRectMake(0, 0 + adjustmentY, deviceRectPortrait.width, deviceRectPortrait.height-adjustmentY)
    : CGRectMake(0, 0 + adjustmentY, deviceRectLandscape.width, deviceRectLandscape.height-adjustmentY);
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
    float sx = (float)screenBonus.size.width / (float)portraitCanvasRect.width;
    float sy = (float)screenBonus.size.height / (float)portraitCanvasRect.height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        label.transform = CGAffineTransformMakeScale(sx, sy);
        label.layer.anchorPoint = CGPointMake(1, 1);
    }
}

+(void) setupParameters: (NSDictionary*)parameters {        // TODO user enum instead of it .
    fixXforRotation = [[parameters objectForKey: @"fixXforRotation"] boolValue];
    fixYforRotation = [[parameters objectForKey: @"fixYforRotation"] boolValue];
    fixWidthforRotation = [[parameters objectForKey: @"fixWidthforRotation"] boolValue];
    fixHeightforRotation = [[parameters objectForKey: @"fixHeightforRotation"] boolValue];
    fixXforDevice = [[parameters objectForKey: @"fixXforDevice"] boolValue];
    fixYforDevice = [[parameters objectForKey: @"fixYforDevice"] boolValue];
    fixWidthforDevice = [[parameters objectForKey: @"fixWidthforDevice"] boolValue];
    fixHeightforDevice = [[parameters objectForKey: @"fixHeightforDevice"] boolValue];
    maintainRatioByX = [[parameters objectForKey: @"maintainRatioByX"] boolValue];
    maintainRatioByY = [[parameters objectForKey: @"maintainRatioByY"] boolValue];
    alignCenterAfterAspectMaintainence = [[parameters objectForKey: @"alignCenterAfterAspectMaintainence"] boolValue];
}

@end
