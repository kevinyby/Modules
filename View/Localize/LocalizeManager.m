#import "LocalizeManager.h"


#ifndef Localize
    #define Localize @"Localize"
#endif


@implementation LocalizeManager


+(NSString*) getLocalized: (NSString*)key {
    return [self getLocalized: key localize:CurrentLocalize];
}


+(NSString*) getLocalized: (NSString*)key localize:(NSString*)localize {
    NSString* tbl = [NSString stringWithFormat: @"%@_%@", Localize, localize];
    return NSLocalizedStringFromTable(key, tbl, nil);
}

@end
