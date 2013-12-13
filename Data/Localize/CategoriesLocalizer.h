#import <Foundation/Foundation.h>
#import "LocalizeManager.h"

#define LOCALIZE_KEY(_key) [CategoriesLocalizer getLocalize: _key]
#define LOCALIZE_KEYS(_item,_attr) [CategoriesLocalizer getLocalize: _item attribute:_attr]

#define ITEM_ATTR_CONNECTOR @"."

@interface CategoriesLocalizer : LocalizeManager

+(void) setCategories: (NSDictionary*)categories;

+(NSString*) getLocalize: (NSString*)key;

+(NSString*) getLocalize: (NSString*)order attribute:(NSString*)attribute;

@end
