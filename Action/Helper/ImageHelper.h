#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject

+(NSMutableArray*) converToContextImages: (NSArray*)array repository:(NSMutableArray*)repository ;

+(UIImage*) applyingAlphaToImage: (UIImage*)image alpha:(CGFloat)alpha ;

@end
