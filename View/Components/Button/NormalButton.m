#import "NormalButton.h"

// _View.h
#import "_Frame.h"
#import "UIView+PropertiesSetter.h"

@implementation NormalButton

- (id)init
{
    self = [super init];
    if (self) {
        [self setSize:[FrameTranslater convertCanvasSize:(CGSize){50,50}]];    // default
        [self setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [self setTitle:@"" forState:UIControlStateNormal];
        self.titleLabel.font  = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize: 20]];
        
        [self addTarget: self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void) buttonTapAction: (id)sender
{
    if (self.didClikcButtonAction) self.didClikcButtonAction(sender);
}

@end
