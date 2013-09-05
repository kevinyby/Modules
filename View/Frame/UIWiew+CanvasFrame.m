
#import "UIWiew+CanvasFrame.h"
#import <objc/runtime.h>


static const char* canvasFrameKey="canvasFrameKey";

@implementation UIView (CanvasFrame)

-(NSValue *)canvasFrame {
    return  objc_getAssociatedObject(self, canvasFrameKey);
}

-(void)setCanvasFrame:(NSValue *)canvasFrame {
    objc_setAssociatedObject(self, canvasFrameKey, canvasFrame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
