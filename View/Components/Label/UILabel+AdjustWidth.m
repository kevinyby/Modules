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
    }
    return self;
}

-(void) adjustWidth {
    CGSize titleSize = [self.text sizeWithFont:self.font];
    CGRect frame = self.frame;
    frame.size.width = titleSize.width;
    self.frame = frame;
}

@end
