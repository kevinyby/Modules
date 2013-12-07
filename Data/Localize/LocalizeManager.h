#import <Foundation/Foundation.h>

// Be carefule , zh-Hans & zh-Hant can recognize by Mac , but not iphone

#define LANGUAGE_en         @"en"
#define LANGUAGE_zh_Hans    @"zh-Hans"      // on mac
#define LANGUAGE_zh_Hant    @"zh-Hant"      // on mac
#define LANGUAGE_zh_CN      @"zh_CN"        // on ios
#define LANGUAGE_zh_TW      @"zh_TW"        // on ios


@interface LocalizeManager : NSObject

+(NSString*) currentLanguage ;
+(void) setCurrentLanguage: (NSString*)language ;


/** You should create "Localize_category_language.strings" with "Localize" prefix in resources*/
+(NSString*) getLocalized: (NSString*)key ;

+(NSString*) getLocalized: (NSString*)key category:(NSString*)category ;

+(NSString*) getLocalized: (NSString*)key category:(NSString*)category language:(NSString*)language  ;

@end
