#import "SearchBarView.h"
#import "FrameTranslater.h"

//#import "ColorHelper.h"
//#import "UIColor+FlatColors.h"

@implementation SearchBarView

@synthesize textField;
@synthesize cancelButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
        [self initializeSubviewsHConstraints];
        [self initializeSubviewsVConstraints];
    }
    return self;
}

-(void) initializeSubviews
{
    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    
    textField = [[UITextField alloc] init];
    
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize:20]];
    
    cancelButton = [[UIButton alloc] init];
    
    [cancelButton setTitle: @"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:  [UIColor colorWithRed:0 green:0.35 blue:1 alpha:1] forState:UIControlStateNormal];
    [cancelButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget: self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];

    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self addSubview: textField];
    [self addSubview: cancelButton];
    
//    [ColorHelper setBorderRecursive: self];
}

-(void) initializeSubviewsHConstraints
{
    float inset = [FrameTranslater convertCanvasHeight: 20.0f];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"|-(inset)-[textField]-(inset)-[cancelButton]-(inset)-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"inset":@(inset)}
                          views:NSDictionaryOfVariableBindings(textField,cancelButton)]];
}

-(void) initializeSubviewsVConstraints
{
    float inset = [FrameTranslater convertCanvasHeight: 5.0f];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-(inset)-[textField]-(inset)-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:@{@"inset":@(inset)}
                          views:NSDictionaryOfVariableBindings(textField)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-(inset)-[cancelButton]-(inset)-|"
                          options:NSLayoutFormatAlignAllBaseline
                          metrics:@{@"inset":@(inset)}
                          views:NSDictionaryOfVariableBindings(cancelButton)]];
}


#pragma mark - Event

-(void) buttonTapAction: (id)sender
{
    [textField resignFirstResponder];
}

@end
