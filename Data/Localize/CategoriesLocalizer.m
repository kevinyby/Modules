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
    
    NSArray* array = [key componentsSeparatedByString:ITEM_ATTR_CONNECTOR];
    NSString* item = [array firstObject];
    NSString* attr = [array lastObject];
    
    NSString* result = nil;
    if (array.count == 0)
    {
        result = [CategoriesLocalizer getGlobalLocalize: key];
        
    } else
    {
        NSString* category = [CategoriesLocalizer getCategoryByItem:item];
        
        if (category == nil || [category length] == 0) {
            
            // get from global
            result = [CategoriesLocalizer getGlobalLocalize: key];
            
            // cannot find again ? ok , make attr as key, and continue find
            if ([result isEqualToString: key]) result = [CategoriesLocalizer getGlobalLocalize: attr];
            
        } else {
            // get from the categories
            result = [LocalizeManager getLocalized: key category:category];
            
            // if not find  , go to the GLOBAL_LOCALIZE to continue find it
            if ([result isEqualToString: key]) result = [CategoriesLocalizer getGlobalLocalize: key];
            
            // cannot find again ? ok , make attr as key, and continue find
            if ([result isEqualToString: key]) result = [CategoriesLocalizer getGlobalLocalize: attr];
            
        }
        
    }
    
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
