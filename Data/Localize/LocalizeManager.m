#import "LocalizeManager.h"

#ifndef LOCALIZE_TABLE_FORMAT
#define LOCALIZE_TABLE_FORMAT @"_%@"
#endif

#ifndef LOCALIZE_PREFIX
#define LOCALIZE_PREFIX @"Localize"
#endif

#define SIMULATOR @"Simulator"
#define ISSIMULATOR [[[UIDevice currentDevice] model] rangeOfString: SIMULATOR].location != NSNotFound

// NSArray
#define IOSSupportedLanguages [[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"]

static NSString* currentLanguage = nil ;

@implementation LocalizeManager

+(void)initialize {
    currentLanguage = [[NSLocale preferredLanguages] firstObject];
    
//    if (ISSIMULATOR) {
        if ([currentLanguage isEqualToString: LANGUAGE_zh_Hans]) currentLanguage = LANGUAGE_zh_CN ;
        else if ([currentLanguage isEqualToString: LANGUAGE_zh_Hant]) currentLanguage = LANGUAGE_zh_TW ;
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
    return [self getLocalized: key category:nil language:currentLanguage];
}

+(NSString*) getLocalized: (NSString*)key category:(NSString*)category {
    return [self getLocalized: key category:category language:currentLanguage];
}

+(NSString*) getLocalized: (NSString*)key category:(NSString*)category language:(NSString*)language  {
    NSString* table = LOCALIZE_PREFIX;
    if (category) table = [table stringByAppendingFormat:LOCALIZE_TABLE_FORMAT, category];
    if (language) table = [table stringByAppendingFormat:LOCALIZE_TABLE_FORMAT, language];
    
    NSString* localizeValue = NSLocalizedStringFromTable(key, table, nil);
    
    // when the same , return nill , so , be sure the key-value are not the same
    if ([localizeValue isEqualToString: key]) localizeValue = nil;
    
    return localizeValue;
}

@end
