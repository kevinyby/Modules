#import "SearchBarView.h"
#import "FrameTranslater.h"
#import "ColorHelper.h"
#import "ViewHelper.h"

// Pair A
#define PLUGIN_EMPTY_STRING @" "

@interface SearchBarTextField : UITextField

@end

@implementation SearchBarTextField

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Pair A
        super.text = PLUGIN_EMPTY_STRING;
    }
    return self;
}

// Pair A
-(void)setText:(NSString *)text
{
    if (! text) text = @"";
    NSString* newText = [PLUGIN_EMPTY_STRING stringByAppendingString: text];
    [super setText: newText];
}

// Pair A
-(NSString *)text
{
    return [super.text substringFromIndex: 1];
}

@end




@implementation SearchBarView

@synthesize textField;
@synthesize cancelButton;

@synthesize delegate;

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
    self.backgroundColor = [ColorHelper parseColor:@[@(189),@(189),@(195)]];
    
    // textfield
    textField = [[SearchBarTextField alloc] init];
    
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize:25]];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeySearch;
    
//    UILabel *magnifyingGlass = [[UILabel alloc] init];
//    NSString* string = [[NSString alloc] initWithUTF8String:"\xF0\x9F\x94\x8D"];
//    [magnifyingGlass setText: string];
//    [magnifyingGlass sizeToFit];
//    [textField setLeftView:magnifyingGlass];
//    [textField setLeftViewMode:UITextFieldViewModeAlways];
    
    
    UISearchBar* searchBar = [[UISearchBar alloc] init];
//    UIImage* image = [searchBar imageForSearchBarIcon:UISearchBarIconSearch state:UIControlStateSelected];    // get nothing

    __block UITextField *searchField = nil;
    [ViewHelper iterateSubView: searchBar class:[UITextField class] handler:^BOOL(id subView) {
        searchField = (UITextField *)subView;
        return NO;
    }];
    
    // The icon is accessible through the 'leftView' property of the UITextField.
    // We set it to the 'rightView' instead.
    if (searchField)
    {
        UIView *searchIcon = searchField.leftView;
        if ([searchIcon isKindOfClass:[UIImageView class]]) {
            NSLog(@"ay-------e");
        }
        textField.leftView = searchIcon;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    
    
    
    // Add a "textFieldDidChange" notification method to the text field control.
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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

-(void) cancelButtonTapAction: (id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewCancelButtonClicked:)]) {
        [delegate searchBarViewCancelButtonClicked: self];
    }
}

// for this PLUGIN_EMPTY_STRING is needed .
-(void) textFieldDidChange:(UITextField*)sender
{
    // Pair A
    if (delegate && [delegate respondsToSelector:@selector(searchBarView:textDidChange:)]) {
        [delegate searchBarView: self textDidChange:sender.text];
    }
}



#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//- (void)textFieldDidEndEditing:(UITextField *)textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Pair A
    if (range.location == 0) {
        return NO;                  // for the PLUGIN_EMPTY_STRING
    }
    return YES;
}
//- (BOOL)textFieldShouldClear:(UITextField *)textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (delegate && [delegate respondsToSelector:@selector(searchBarViewSearchButtonClicked:)]) {
        [delegate searchBarViewSearchButtonClicked: self];
    }
    return YES;
}


@end
