
#import "UIWiew+CanvasFrame.h"
#import <objc/runtime.h>

static const char* designFrameKey = "designFrameKey";
static const char* canvasFrameKey = "canvasFrameKey";
static const char* rotateCanvasFrameKey = "rotateCanvasFrameKey";

@implementation UIView (CanvasFrame)

-(NSValue *)designFrame {
    return  objc_getAssociatedObject(self, designFrameKey);
}

-(void)setDesignFrame:(NSValue *)designFrame {
    objc_setAssociatedObject(self, designFrameKey, designFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSValue *)canvasFrame {
    return  objc_getAssociatedObject(self, canvasFrameKey);
}

-(void)setCanvasFrame:(NSValue *)canvasFrame {
    objc_setAssociatedObject(self, canvasFrameKey, canvasFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSValue *)rotateCanvasFrame {
    return  objc_getAssociatedObject(self, rotateCanvasFrameKey);
}

-(void)setRotateCanvasFrame:(NSValue *)rotateCanvasFrame {
    objc_setAssociatedObject(self, rotateCanvasFrameKey, rotateCanvasFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
