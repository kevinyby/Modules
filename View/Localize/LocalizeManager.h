#import <Foundation/Foundation.h>


#define Localize_EN_US @"en"


// Be carefule , zh-Hans & zh-Hant can recognize by Mac , but not iphone
#define Localize_zh_Hans @"zh-Hans"  // on mac
#define Localize_zh_Hant @"zh-Hant"  // on mac

#define Localize_zh_CN @"zh_CN"     // on ios
#define Localize_zh_TW @"zh_TW"     // on ios


// NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];


// return value is NSArray
#define IOSSupportedLanguages [[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"]



// return value is NSString
#define CurrentLocalize [[NSLocale preferredLanguages] objectAtIndex: 0]


@interface LocalizeManager : NSObject

+(NSString*) getLocalized: (NSString*)key ;

+(NSString*) getLocalized: (NSString*)key localize:(NSString*)localize ;

@end
