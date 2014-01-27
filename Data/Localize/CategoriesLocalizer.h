#import <Foundation/Foundation.h>
#import "LocalizeManager.h"

#define LOCALIZE_KEY_CONNECTOR @"."
#define LOCALIZE_CONNECT_KEYS(_item, _attr) [CategoriesLocalizer connectKeys:_item attribute:_attr]

#define LOCALIZE_KEY(_key) [CategoriesLocalizer getLocalize: _key]
#define LOCALIZE_MESSAGE(_key) [CategoriesLocalizer getMessageLocalize: _key]

 #define LOCALIZE_MESSAGE_FORMAT(_key, args...) [NSString stringWithFormat: LOCALIZE_MESSAGE(_key), ##args]


// Convention:

// First :
// categories forbid that two different keys have the same value . i.e.
// @{@"HumanResource":[@"item_A", @"item_B"], @"Finance":[@"item_A",@"item_C"]}
// the @"item_A" is duplicated , avoid that !!! importmant .

// Second :
// in .strings files , key and localize value do not use the same charachters. i.e.

@interface CategoriesLocalizer : LocalizeManager

+(NSDictionary*) categories;
+(void) setCategories: (NSDictionary*)categories;

+(NSString*) getLocalize: (NSString*)key;
+(NSString*) getMessageLocalize: (NSString*)key;
+(NSString*) connectKeys: (NSString*) item attribute:(NSString*)attribute;

@end
