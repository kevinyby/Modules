#import "NormalTextField.h"

#import "_Frame.h"

// TODO : Subclass a inner shadow view.
@implementation NormalTextField

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.adjustsFontSizeToFitWidth = YES;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize:20]];
    }
    return self;
}

@end
