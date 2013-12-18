#import <Foundation/Foundation.h>
#import "LocalizeManager.h"


#define LOCALIZE_KEY(_key) [CategoriesLocalizer getLocalize: _key]
#define LOCALIZE_MESSAGE(_key) [CategoriesLocalizer getMessageLocalize: _key]

#define ITEM_ATTR_CONNECTOR @"."
#define CONNECT_KEYS(_item, _attr) [CategoriesLocalizer connectKeys:_item attribute:_attr]


@interface CategoriesLocalizer : LocalizeManager

+(NSDictionary*) categories;
+(void) setCategories: (NSDictionary*)categories;

+(NSString*) getLocalize: (NSString*)key;
+(NSString*) getMessageLocalize: (NSString*)key;
+(NSString*) connectKeys: (NSString*) item attribute:(NSString*)attribute;

@end
