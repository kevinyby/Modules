#import "HTTPGetRequest.h"

@implementation HTTPGetRequest

#pragma mark - Overwrite Methods
-(NSMutableURLRequest*) getURLRequest: (NSString*)urlString parameters:(NSDictionary*)parameters {
    
    NSMutableString* parameterString = [NSMutableString stringWithString: urlString];
    
    for(NSString* key in parameters) {
        NSString* value = [parameters objectForKey: key];
        
        if ([parameterString rangeOfString: @"?"].location != NSNotFound) {
            [parameterString appendFormat: @"&%@=%@", key, value];
        } else {
            [parameterString appendFormat: @"?%@=%@", key, value];
        }
    }
    
    NSURL* url = [NSURL URLWithString: parameterString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:NetworkTimeOutInterval] ;
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

@end
