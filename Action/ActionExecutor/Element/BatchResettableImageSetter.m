#import "BatchResettableImageSetter.h"

@implementation BatchResettableImageSetter

-(void) initComponent {
    objectsRegister = [[NSMutableArray alloc] init];
}

-(void) execute:(NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times {
    if (objects){
        [objectsRegister addObjectsFromArray: objects];
        [super execute: config objects: objects values:values times:times];
    } else {
        config ? nil : [super execute: config objects:objectsRegister values:values times:times];   // objects == nil && config == nil : reset.
        [objectsRegister removeAllObjects];
    }
}

@end
