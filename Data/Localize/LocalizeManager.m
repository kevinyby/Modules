#import "LocalizeManager.h"

#define IOSSupportedLanguages [[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"]

#define ISSIMULATOR [[[UIDevice currentDevice] model] rangeOfString: @"Simulator"].location != NSNotFound


static NSString* currentLanguage = nil ;

@implementation LocalizeManager

+(void)initialize {
    currentLanguage = [[NSLocale preferredLanguages] firstObject];
    
//    if (ISSIMULATOR) {
    if ([currentLanguage isEqualToString: LANGUAGE_zh_Hans]) {
       currentLanguage = LANGUAGE_zh_CN ;
        
    } else if ([currentLanguage isEqualToString: LANGUAGE_zh_Hant]) {
       currentLanguage = LANGUAGE_zh_TW ;
        
    }
//    }
    
    [super initialize];
}


+(NSString*) currentLanguage {
    return currentLanguage;
}

+(void) setCurrentLanguage: (NSString*)language {
    if (! language) return;
    currentLanguage = language;
}


+(NSString*) getLocalized: (NSString*)key {
    return [self getLocalized: key table:currentLanguage];
}

+(NSString*) getLocalized:(NSString *)key table:(NSString*)table
{
    return NSLocalizedStringFromTable(key, table, nil);
}

@end
