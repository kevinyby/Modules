#import "UILabel+UIFont.h"

@implementation UILabel (UIFont)

// Just For Most situation
// http://iphonedevwiki.net/index.php/UIFont
#define FONT_BOLD        @"Bold"
#define FONT_ITALIC      @"Italic"
#define FONT_BOLDITALIC  @"BoldItalic"

#define FONT_MT @"MT"

-(void) setBoldToFont {
    UIFont *currentFont = self.font;
    
    CGFloat currentFontSize = currentFont.pointSize;
    NSString* currentFontName = currentFont.fontName;
    NSString* fontName = currentFontName;
    
    //  ------->
    BOOL hasMTsuffix = [fontName hasSuffix: FONT_MT];
    if (hasMTsuffix) {
        fontName = [fontName stringByReplacingOccurrencesOfString:FONT_MT withString:@""];
    }
    //  <-------
    
    if ([fontName rangeOfString: FONT_BOLD].location != NSNotFound) return; // Blod already
    NSString* suffix = [fontName rangeOfString: FONT_ITALIC].location != NSNotFound ? FONT_BOLDITALIC : FONT_BOLD;
    NSString* newFontName = [NSString stringWithFormat:@"%@-%@",fontName, suffix];
    
    //  ------->
    if (hasMTsuffix) {
        newFontName = [newFontName stringByAppendingString: FONT_MT];
    }
    //  <-------
    
    UIFont *newFont = [UIFont fontWithName: newFontName size:currentFontSize];
    
    self.font = newFont;
}

-(void) setItalicToFont {
    UIFont *currentFont = self.font;
    
    CGFloat currentFontSize = currentFont.pointSize;
    NSString* currentFontName = currentFont.fontName;
    NSString* fontName = currentFontName;
    
    //  ------->
    BOOL hasMTsuffix = [fontName hasSuffix: FONT_MT];
    if (hasMTsuffix) {
        fontName = [fontName stringByReplacingOccurrencesOfString:FONT_MT withString:@""];
    }
    //  <-------
    
    if ([fontName rangeOfString: FONT_ITALIC].location != NSNotFound) return; // Blod already
    NSString* suffix = [fontName rangeOfString: FONT_BOLD].location != NSNotFound ? FONT_BOLDITALIC : FONT_ITALIC;
    NSString* newFontName = [NSString stringWithFormat:@"%@-%@",fontName,suffix];
    
    //  ------->
    if (hasMTsuffix) {
        newFontName = [newFontName stringByAppendingString: FONT_MT];
    }
    //  <-------
    
    
    UIFont *newFont = [UIFont fontWithName:newFontName size:currentFontSize];
    
    self.font = newFont;
}


@end
