//
//  NSArray+Additions.h


@interface NSArray (SafeGetter)

/** @return if index >= array.count , will return nil **/
-(id)safeObjectAtIndex:(NSUInteger)index;

@end


@interface NSArray (ContainsObject)

-(BOOL) contains: (id)anObject;

-(NSUInteger) index: (id)anObject;

@end