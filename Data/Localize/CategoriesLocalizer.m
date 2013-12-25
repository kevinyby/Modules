#import "CategoriesLocalizer.h"

#define LOCALIZE_GLOBAL_PRE  @"GLOBAL"
#define LOCALIZE_MESSAGE_PRE @"MESSAGE"

// dic with array in it
static NSDictionary* categories;

@implementation CategoriesLocalizer


+(void) setCategories: (NSDictionary*)_categories
{
    categories = _categories;
}

+(NSDictionary*) categories
{
    return categories;
}


/**
 *
 *  Get localize in Localize_(category)_(language).strings
 *
 *  @param key key with format "Employee.employeeNO"
 *
 *  @return the localize values
 */
+(NSString*) getLocalize: (NSString*)key
{
    NSString* result = nil;
    
    if ([key rangeOfString: ITEM_ATTR_CONNECTOR].location == NSNotFound) {
        result = [CategoriesLocalizer getGlobalLocalize: key];
        
    } else {
        
        NSArray* array = [key componentsSeparatedByString:ITEM_ATTR_CONNECTOR];
        NSString* item = [array firstObject];
        NSString* attr = [array lastObject];
        
        // get category by item
        NSString* category = [CategoriesLocalizer getCategoryByItem:item];
        // get from the categories by connected key
        if (category) result = [LocalizeManager getLocalized: key category:category];
        
        // if not find  , go to the GLOBAL_LOCALIZE to continue find it
        if (!result) result = [CategoriesLocalizer getGlobalLocalize: attr];
        if (!result) result = [CategoriesLocalizer getGlobalLocalize: key];
    }
    
    if (!result) result = key;
    
    return result;
}

+(NSString*) connectKeys: (NSString*) item attribute:(NSString*)attribute
{
    return [item stringByAppendingFormat:@"%@%@", ITEM_ATTR_CONNECTOR, attribute];
}

+(NSString*) getGlobalLocalize: (NSString*)key
{
    return [LocalizeManager getLocalized: key category:LOCALIZE_GLOBAL_PRE];
}
    
+(NSString*) getMessageLocalize: (NSString*)key
{
    return [LocalizeManager getLocalized: key category:LOCALIZE_MESSAGE_PRE];
}

+(NSString*) getCategoryByItem: (NSString*)item
{
    for (NSString* category in categories) {
        NSArray* items = [categories objectForKey: category];
        for (NSString* atom in items)  if ([atom isEqualToString: item]) return category;
    }
    return nil;
}

@end
