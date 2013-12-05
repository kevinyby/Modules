#import "NormalLabel.h"

#import "_Frame.h"
#import "_Label.h"

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
    }
    return self;
}


-(void) setText:(NSString *)text {
    [super setText: text];
    [self adjustWidthToFontText];
}


@end
