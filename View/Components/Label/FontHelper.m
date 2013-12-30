#import "FontHelper.h"

#include <CoreText/CoreText.h>

@implementation FontHelper

+(void) listAllFontNames
{
    NSArray* familiesNames = [UIFont familyNames];
    NSLog(@"%@", familiesNames);
    for (NSString* family in familiesNames) {
        NSArray* array = [UIFont fontNamesForFamilyName: family];
        NSLog(@"%@ : %@", family, array);
    }
    
    UIFont* font1 = [UIFont systemFontOfSize: [UIFont systemFontSize]];
    NSLog(@"%@ - %f", font1.fontName, font1.pointSize);
    
    UIFont* font2 = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    NSLog(@"%@ - %f", font2.fontName, font2.pointSize);
    
    UIFont* font3 = [UIFont italicSystemFontOfSize: [UIFont buttonFontSize]];
    NSLog(@"%@ - %f", font3.fontName, font3.pointSize);
    
}


// need CoreText.framework
+(UIFont*) getFontFromTTFFile: (NSString*)ttfFilePath withSize:(int)fontSize {
    
    if ([ttfFilePath isEqualToString: [ttfFilePath lastPathComponent]]) {
        NSString* bundlepath = [[NSBundle mainBundle] resourcePath];
        ttfFilePath = [bundlepath stringByAppendingPathComponent: ttfFilePath];
    }
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([ttfFilePath UTF8String]);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    
    // get the font name
    NSString *fontName = (__bridge_transfer NSString *)CGFontCopyPostScriptName(fontRef);
    CTFontManagerRegisterGraphicsFont(fontRef, nil);
    CGFontRelease(fontRef);
    
    // instance a UIFont
    UIFont* font = [UIFont fontWithName: fontName size:fontSize];
    return font;
}










// Just For Most situation
// http://iphonedevwiki.net/index.php/UIFont
#define FONT_BOLD        @"Bold"
#define FONT_ITALIC      @"Italic"
#define FONT_BOLDITALIC  @"BoldItalic"

#define FONT_MT @"MT"

+(void) setBoldToFont: (UILabel*)label
{
    UIFont *currentFont = label.font;
    
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
    
    label.font = newFont;
}

+(void) setItalicToFont: (UILabel*)label
{
    UIFont *currentFont = label.font;
    
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
    
    label.font = newFont;
}

@end
