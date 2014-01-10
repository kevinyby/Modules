#import "NormalLabel.h"

#import "_Frame.h"
#import "UIView+PropertiesSetter.h"
#import "UILabel+AdjustWidth.h"

@implementation NormalLabel

// http://stackoverflow.com/a/4359845/1749293
// http://stackoverflow.com/a/14306893/1749293
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultVariable];
    }
    return self;
}

-(void) setDefaultVariable
{
    self.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize: 25]];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.highlightedTextColor = [UIColor blackColor];
    //		self.textAlignment = NSTextAlignmentCenter;
    
    [self setSizeHeight: [FrameTranslater convertCanvasHeight: 30]]; // default
}


-(void) setText:(NSString *)text {
    NSString* oldText = self.text;
    [super setText: text];
    [self adjustWidthToFontText];
    if (self.didSetTextBlock) self.didSetTextBlock(self, text, oldText);
}


@end
