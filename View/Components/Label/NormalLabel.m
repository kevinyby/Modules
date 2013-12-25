#import "NormalLabel.h"

#import "_Frame.h"
#import "UIView+PropertiesSetter.h"
#import "UILabel+AdjustWidth.h"

@implementation NormalLabel

- (id)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize: 25]];
		self.textColor = [UIColor blackColor];
		self.backgroundColor = [UIColor clearColor];
		self.highlightedTextColor = [UIColor blackColor];
		self.textAlignment = NSTextAlignmentCenter;
        
        [self setSizeHeight: [FrameTranslater convertCanvasHeight: 30]]; // default
    }
    return self;
}


-(void) setText:(NSString *)text {
    NSString* oldText = self.text;
    [super setText: text];
    [self adjustWidthToFontText];
    if (self.didSetTextBlock) self.didSetTextBlock(self, text, oldText);
}


@end
