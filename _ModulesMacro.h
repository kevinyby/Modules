//
//  ModulesMacro.h

// And Other Variable : sel_getName(_cmd) ,  __FILE__ , __FUNCTION__ , __PRETTY_FUNCTION__ , __LINE__

#ifdef DEBUG
#define DLOG(_format,args...)  printf("%s (%d):   %s\n",__PRETTY_FUNCTION__ , __LINE__,[[NSString stringWithFormat:(_format),##args] UTF8String])
#else
#define DLOG(_format,args...)
#endif
