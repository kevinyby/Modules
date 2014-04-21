#import "SearchBarView.h"
#import "FrameTranslater.h"
#import "ColorHelper.h"
#import "ViewHelper.h"
#import "UIView+PropertiesSetter.h"


@implementation SearchBarView

@synthesize textField;
@synthesize cancelButton;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
        [self setSubviewsVConstraints];
    }
    return self;
}

-(void) initializeSubviews
{
    self.backgroundColor = [ColorHelper parseColor:@[@(189),@(189),@(195)]];
    
    // textfield
    textField = [[UITextField alloc] init];
    
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize:25]];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    // Add a "textFieldDidChange" notification method to the text field control.
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    // insert the search icon/ magnify glass icon
    // Google "Emoji" for more informations : http://stackoverflow.com/a/11815568
    
//    UILabel *magnifyingGlass = [[UILabel alloc] init];
//    NSString* string = [[NSString alloc] initWithUTF8String:"\xF0\x9F\x8D\xB0"]; // \xF0\x9F\x94\x8D
//    magnifyingGlass.text = string;
//    [magnifyingGlass sizeToFit];
//    textField.leftView = magnifyingGlass;
//    textField.leftViewMode = UITextFieldViewModeAlways;
    
    // cancel button
    cancelButton = [[UIButton alloc] init];
    
    [cancelButton setTitle: @"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:  cancelButton.tintColor forState:UIControlStateNormal];
    [cancelButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [cancelButton.titleLabel.font fontWithSize: [FrameTranslater convertFontSize: 25]];
    [cancelButton addTarget: self action:@selector(cancelButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];

    // constraints
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview: textField];
    [self addSubview: cancelButton];
    
//    [ColorHelper setBorderRecursive: self];
}

-(void)setHiddenCancelButton:(BOOL)hidden
{
    cancelButton.hidden = hidden;
    if (hidden) [self setSubviewsVConstraints];
}

-(void) setSubviewsVConstraints
{
    [self removeConstraints: self.constraints];
    [self initializeSubviewsHConstraints];
    [self initializeSubviewsVConstraints];
}

-(void) initializeSubviewsHConstraints
{
    float inset = [FrameTranslater convertCanvasHeight: 20.0f];
    NSString* format = nil;
    if (cancelButton.hidden) {
        format = @"|-(inset)-[textField]-(inset)-|";
    } else {
        format = @"|-(inset)-[textField]-(inset)-[cancelButton]-(inset)-|";
    }
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:format
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

-(void) cancelButtonTapAction: (id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewCancelButtonClicked:)]) {
        [delegate searchBarViewCancelButtonClicked: self];
    }
}

-(void) textFieldDidChange:(UITextField*)sender
{
    NSString* text = sender.text;
    if (delegate && [delegate respondsToSelector:@selector(searchBarView:textDidChange:)]) {
        [delegate searchBarView: self textDidChange:text];
    }
}



#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//- (void)textFieldDidEndEditing:(UITextField *)textField
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//- (BOOL)textFieldShouldClear:(UITextField *)textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewSearchButtonClicked:)]) {
        [delegate searchBarViewSearchButtonClicked: self];
    }
    return YES;
}


@end
