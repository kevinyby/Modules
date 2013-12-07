#import "NormalLabel.h"

#import "_View.h"

@implementation NormalLabel

- (id)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize: 25]];
		self.textColor = [UIColor blackColor];
		self.backgroundColor = [UIColor clearColor];
		self.highlightedTextColor = [UIColor blackColor];
		self.textAlignment = UITextAlignmentCenter;
        
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
