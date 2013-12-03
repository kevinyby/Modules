#import <Foundation/Foundation.h>

#define NSBUNDLE_PATH [[NSBundle mainBundle] resourcePath]
#define BUNDLEFILE_PATH(__file_name) [NSBUNDLE_PATH stringByAppendingPathComponent: __file_name]

@interface JsonFileManager : NSObject


+(id) getJson: (NSString*)jsonFileName;

@end
