#import "NormalTextField.h"

#import "_Frame.h"

// TODO : Subclass a inner shadow view.
@implementation NormalTextField

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultVariables];
    }
    return self;
}

-(void) setDefaultVariables
{
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.adjustsFontSizeToFitWidth = YES;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize:20]];
}

@end
