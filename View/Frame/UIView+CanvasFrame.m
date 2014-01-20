
#import "UIView+CanvasFrame.h"
#import <objc/runtime.h>

static const char* designFrameKey = "designFrameKey";
static const char* actualFrameKey = "actualFrameKey";
static const char* rotateActualFrameKey = "rotateActualFrameKey";

@implementation UIView (CanvasFrame)

// designFrame == canvasFrame
-(NSValue *)designFrame {
    return  objc_getAssociatedObject(self, designFrameKey);
}

-(void)setDesignFrame:(NSValue *)designFrame {
    objc_setAssociatedObject(self, designFrameKey, designFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSValue *)actualFrame {
    return  objc_getAssociatedObject(self, actualFrameKey);
}

-(void)setActualFrame:(NSValue *)actualFrame {
    objc_setAssociatedObject(self, actualFrameKey, actualFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSValue *)rotateActualFrame {
    return  objc_getAssociatedObject(self, rotateActualFrameKey);
}

-(void)setRotateActualFrame:(NSValue *)rotateCanvasFrame {
    objc_setAssociatedObject(self, rotateActualFrameKey, rotateCanvasFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
