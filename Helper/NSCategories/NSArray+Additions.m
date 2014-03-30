//
//  NSArray+Additions.m

#import "NSArray+Additions.h"

@implementation NSArray (SafeGetter)

-(id)safeObjectAtIndex:(NSUInteger)index
{
    return index >= self.count ? nil : [self objectAtIndex: index];
}

@end



@implementation NSArray (ContainsObject)

-(BOOL) contains: (id)anObject;
{
    BOOL isContains = [self containsObject: anObject];
    if (isContains) return YES;
    
    // anObject is nsstring
    if ([anObject isKindOfClass:[NSString class]]) {
        
        BOOL flag = NO;
        for (id object in self) {
            if ([object isKindOfClass:[NSString class]]) {
                NSString* str = (NSString*)object;
                if ([str isEqualToString: anObject]) {
                    flag = YES;
                    break;
                }
            }
        }
        
        return flag;
    }
    
    return NO;
}

-(NSUInteger) index: (id)anObject
{
    NSUInteger index = [self indexOfObject:anObject];
    
    if (index != NSNotFound) return index;
    
    // anObject is nsstring
    if ([anObject isKindOfClass:[NSString class]]) {
        
        for (NSUInteger i = 0; i < self.count; i++) {
            id object = [self objectAtIndex: i];
            if ([object isKindOfClass:[NSString class]]) {
                NSString* str = (NSString*)object;
                if ([str isEqualToString: anObject]) {
                    index = i;
                    break;
                }
            }
        }
        
    }
    
    return index;
}

@end