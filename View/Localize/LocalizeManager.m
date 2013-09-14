#import "LocalizeManager.h"


#ifndef Localize
    #define Localize @"Localize"
#endif

#define SIMULATOR @"Simulator"

#define ISSIMULATOR [[[UIDevice currentDevice] model] rangeOfString: SIMULATOR].location != NSNotFound

static NSString* currentLocalize ;

@implementation LocalizeManager

+(void)initialize {
    currentLocalize = IOSCurrentLocalize;
    
    if (ISSIMULATOR) {
        if ([currentLocalize isEqualToString: Localize_zh_Hans]) currentLocalize = Localize_zh_CN ;
        else if ([currentLocalize isEqualToString: Localize_zh_Hant]) currentLocalize = Localize_zh_TW ;
    }
    
    [super initialize];
}

+(void) setCurrentLocalize: (NSString*)localize {
    currentLocalize = localize;
}


+(NSString*) getLocalized: (NSString*)key {
    return [self getLocalized: key localize:currentLocalize];
}


+(NSString*) getLocalized: (NSString*)key localize:(NSString*)localize {
    NSString* tbl = [NSString stringWithFormat: @"%@_%@", Localize, localize];
    return NSLocalizedStringFromTable(key, tbl, nil);
}

@end
