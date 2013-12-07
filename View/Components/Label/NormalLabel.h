#import "StrokeLabel.h"

@interface NormalLabel : StrokeLabel

// when after adjustWidthToFontText , invoke it
@property (copy) void (^didSetTextBlock)(NormalLabel* label, NSString* newText, NSString* oldText);

@end
