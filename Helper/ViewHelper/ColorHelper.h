@class CAGradientLayer;

@interface ColorHelper : NSObject

+(void) applyGradient: (UIImageView*)view config:(NSDictionary*)config flag:(BOOL*)flag ;

+(UIColor*) parseColor: (id)config ;
+(CAGradientLayer*) assembleGradientLayer: (NSDictionary*)config ;
+(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha;



#pragma mark -
#pragma mark -  Convenient Methods

// UIView or CALayer
+(void) setBorder: (id)obj;
+(void) setBorderRecursive: (id)obj;
+(void) setBorder: (id)obj color:(id)color;

+(void) clearBorder: (id)obj;
+(void) clearBorderRecursive: (id)obj;


+(void) setBackGround: (id)obj;
+(void) setBackGround: (id)obj color:(id)color;

@end
