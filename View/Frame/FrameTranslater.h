#import <Foundation/Foundation.h>

#define Frame_fixXforRotation @"fixXforRotation"
#define Frame_fixYforRotation @"fixYforRotation"
#define Frame_fixWidthforRotation @"fixWidthforRotation"
#define Frame_fixHeightforRotation @"fixHeightforRotation"

#define Frame_fixXforDevice @"fixXforDevice"
#define Frame_fixYforDevice @"fixYforDevice"
#define Frame_fixWidthforDevice @"fixWidthforDevice"
#define Frame_fixHeightforDevice @"fixHeightforDevice"

#define Frame_maintainRatioByX @"maintainRatioByX"
#define Frame_maintainRatioByY @"maintainRatioByY"
#define Frame_alignCenterAfterAspectMaintainence @"alignCenterAfterAspectMaintainence"
#define Frame_notShiftPositionToFollowAspectMaintanence @"notShiftPositionToFollowAspectMaintanence"

@interface FrameTranslater : NSObject

+(CGSize) getPortraitCanvasSize ;
+(CGSize) setLandscapeCanvasSize ;
+(void) setPortraitCanvasSize: (CGSize)size ;
+(void) setLandscapeCanvasSize: (CGSize)size ;

+(CGRect) getFrame: (UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame parameters:(NSDictionary*)parameters ;

+(void) adjustLabelSize: (UILabel*)label orientation:(UIInterfaceOrientation)orientation canvasFrame:(CGRect)canvasFrame text:(NSString*)text ;

@end
