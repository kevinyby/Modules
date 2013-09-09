#import "LocalizeManager.h"


#ifndef Localize
    #define Localize @"Localize"
#endif

static NSString* currentLocalize ;

@implementation LocalizeManager

+(void)initialize {
    currentLocalize = IOSCurrentLocalize;
    [super initialize];
}

+(void) setLurrentLocalize: (NSString*)localize {
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
