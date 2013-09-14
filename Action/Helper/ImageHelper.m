#import "ImageHelper.h"

@implementation ImageHelper

+(NSMutableArray*) converToContextImages: (NSArray*)array repository:(NSMutableArray*)repository {
    if (!repository) repository = [NSMutableArray array];
    for (int i = 0 ; i < array.count ; i++){
        UIImage* image = [array objectAtIndex: i];
        UIGraphicsBeginImageContext(image.size);
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        [image drawInRect: rect];
        UIImage* symbolImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (symbolImage)[repository addObject: symbolImage];
    }
    return repository;
}

// apply alpha to image , note that the image is another new instance
+(UIImage*) applyingAlphaToImage: (UIImage*)image alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
