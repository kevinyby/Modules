//
//  ModulesMacro.h

// And Other Variable : sel_getName(_cmd) ,  __FILE__ , __FUNCTION__ , __PRETTY_FUNCTION__ , __LINE__

#ifdef DEBUG
#define DLOG(_format,args...)  printf("%s (%d):   %s\n",__PRETTY_FUNCTION__ , __LINE__,[[NSString stringWithFormat:(_format),##args] UTF8String])
#else
#define DLOG(_format,args...)
#endif


#define DLOGSize(size) NSLog(@"(%f,%f)", size.width, size.height)

#define DLOGRect(rect) NSLog(@"(%f,%f,%f,%f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)

#define DLOGFloat(_x)  NSLog(@"%f", _x)
