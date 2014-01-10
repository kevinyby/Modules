#import "NormalButton.h"

// _View.h
#import "_Frame.h"
#import "UIView+PropertiesSetter.h"

@implementation NormalButton


+ (id)buttonWithType:(UIButtonType)buttonType {
    NormalButton* button = [super buttonWithType:buttonType];
    [button initializeValues];
    return button;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeValues];
    }
    return self;
}

-(void) initializeValues
{
    [self setSize:[FrameTranslater convertCanvasSize:(CGSize){50,50}]];    // default
    [self setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    self.titleLabel.font  = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize: 20]];
    
    [self addTarget: self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void) buttonTapAction: (id)sender
{
    if (self.didClikcButtonAction) self.didClikcButtonAction(sender);
}

@end
