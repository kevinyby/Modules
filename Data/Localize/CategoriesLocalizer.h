#import <Foundation/Foundation.h>
#import "LocalizeManager.h"

#define LOCALIZE_GLOBAL(_key)
#define LOCALIZE_MESSAGE(_key)

#define LOCALIZE_KEY(_key) [CategoriesLocalizer getLocalize: _key]
#define ITEM_ATTR_CONNECTOR @"."
#define LOCALIZE_KEYS(_item,_attr) [CategoriesLocalizer getLocalize: _item attribute:_attr]


@interface CategoriesLocalizer : LocalizeManager

+(NSDictionary*) categories;
+(void) setCategories: (NSDictionary*)categories;

+(NSString*) getLocalize: (NSString*)key;
+(NSString*) getLocalize: (NSString*)order attribute:(NSString*)attribute;

@end
