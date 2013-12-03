#import "CategoriesLocalizer.h"
#import "LocalizeManager.h"

#define GLOBAL_LOCALIZE_PRE @"G"

// dic with array in it
static NSDictionary* categories;

@implementation CategoriesLocalizer


+(void) setCategories: (NSDictionary*)_categories
{
    categories = _categories;
}


+(NSString*) getLocalize: (NSString*)order attribute:(NSString*)attribute
{
    return [CategoriesLocalizer getLocalize: [NSString stringWithFormat:@"%@%@%@", order, ITEM_ATTR_CONNECTOR, attribute]];
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
        NSString* category = [CategoriesLocalizer getCategory:item];
        
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



#pragma mark - Private Methods

+(NSString*) getGlobalLocalize: (NSString*)key
{
    return [LocalizeManager getLocalized: key category:GLOBAL_LOCALIZE_PRE];
}

+(NSString*) getCategory: (NSString*)item
{
    for (NSString* category in categories) {
        NSArray* items = [categories objectForKey: category];
        for (NSString* atom in items)  if ([atom isEqualToString: item]) return category;
    }
    return nil;
}

@end
