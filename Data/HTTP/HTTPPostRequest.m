#import "HTTPPostRequest.h"

@implementation HTTPPostRequest

#pragma mark - Overwrite Methods
-(NSMutableURLRequest*) getURLRequest: (NSString*)urlString parameters:(NSDictionary*)parameters {
    
    NSURL* url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:NetworkTimeOutInterval] ;
    
    
    NSMutableString* parameterString = [NSMutableString stringWithCapacity:0];
    
    BOOL andFlag = NO;
    for(NSString* key in parameters) {
        NSString* value = [parameters objectForKey: key];
        if(!andFlag) {
            [parameterString appendFormat: @"%@=%@", key, value];
            andFlag = YES;
        } else {
            [parameterString appendFormat: @"&%@=%@", key, value];
        }
    }
    
    
    NSMutableData* requestData = [NSMutableData dataWithData: [parameterString dataUsingEncoding: NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: requestData];
    
    return request;
}

@end
