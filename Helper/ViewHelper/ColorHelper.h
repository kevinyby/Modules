@class CAGradientLayer;

@interface ColorHelper : NSObject

+(void) applyGradient: (UIImageView*)view config:(NSDictionary*)config flag:(BOOL*)flag ;

+(UIColor*) parseColor: (id)config ;
+(CAGradientLayer*) assembleGradientLayer: (NSDictionary*)config ;
+(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha ;



#pragma mark -
#pragma mark -  Convenient Methods

+(void) setBorder: (UIView*)view;
+(void) setBorder: (UIView*)view color:(UIColor*)color;

+(void) setBackGround: (UIView*)view;
+(void) setBackGround: (UIView*)view color:(UIColor*)color;

@end
