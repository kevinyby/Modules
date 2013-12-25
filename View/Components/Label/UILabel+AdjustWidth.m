#import "UILabel+AdjustWidth.h"

@implementation UILabel (AdjustWidth)

- (id)initWithText:(NSString*)text
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"Arial" size:20];
		self.textColor = [UIColor blackColor];
		self.backgroundColor = [UIColor clearColor];
		self.highlightedTextColor = [UIColor blackColor];
		self.textAlignment = NSTextAlignmentCenter;
		self.text = text;
        if (text)[self adjustWidthToFontText];
    }
    return self;
}

// Take a look :
// iOS Development: You're Doing It Wrong
//http://doing-it-wrong.mikeweller.com/2012/07/youre-doing-it-wrong-2-sizing-labels.html
// Am i doing wrong here ?
// https://github.com/MikeWeller/ButtonInsetsPlayground   comment line 159 [self sizeButtonToFit] to see .
-(void) adjustWidthToFontText {
    CGSize titleSize = [self.text sizeWithFont:self.font];
    CGRect frame = self.frame;
    frame.size.width = titleSize.width;
    self.frame = frame;
}

@end
