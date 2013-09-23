#import "HTTPUploader.h"
#import "NSString+Base64.h"


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_3
#define RANDOM(x) arc4random_uniform(x)
#else
#define RANDOM(x) arc4random() % x
#endif


#define ASCII_Begin 33
#define ASCII_Over 126

#define BoundaryLength 30
#define Math_Random  RANDOM(10000000) * 0.0000001  // [0, 1)


@implementation HTTPUploader

/**
 *  @parameter
 *      @required content:
 *          NSData with key UPLOAD_Data
 *          NSString with key UPLOAD_FileName
 *      @optional content:
 *          NSString with key UPLOAD_MIMEType
 *          NSDictionary with key UPLOAD_FormParameters
 **/
-(NSMutableURLRequest*) getURLRequest: (NSString*)urlString parameters:(NSDictionary*)parameters {

    NSURL* url = [NSURL URLWithString: urlString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:NetworkTimeOutInterval] ;
    
    

    [request setHTTPMethod:@"POST"];
    [self setUploadData: request parameters:parameters];
    
    return request;
}

-(void) setUploadData: (NSMutableURLRequest*)request parameters:(NSDictionary*)parameters {
    NSData* uploadData = [parameters objectForKey: UPLOAD_Data];                    // required !!
    NSString* fileName = [parameters objectForKey: UPLOAD_FileName];
    NSString* contentType = [parameters objectForKey: UPLOAD_MIMEType];          // image/jpeg ...
    NSDictionary* formParameters = [parameters objectForKey: UPLOAD_FormParameters];
    
    NSString* boundaryCharacters = [HTTPUploader randomCharactersByCount: BoundaryLength];
    NSString* boundary = [NSString stringWithFormat: @"----%@", boundaryCharacters];
    
    // set header
    NSString *headerContentType = [NSString stringWithFormat: @"multipart/form-data; boundary=%@",boundary];
    [request addValue: headerContentType forHTTPHeaderField:@"Content-Type"];
    
    // set body
    NSMutableData* body = [NSMutableData dataWithCapacity: 0];
    
    // first , set the basic
    [body appendData: [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSISOLatin2StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSISOLatin2StringEncoding]];
    [body appendData: [[NSString stringWithFormat: @"Content-Type: %@\r\n\r\n", contentType] dataUsingEncoding:NSISOLatin2StringEncoding]];
    
    // second , set uploadData
    [body appendData: uploadData];
    
    // second , set the other parameters in this post form
    [self appendParametersTo: body parameters: formParameters boundary:boundary];
    
    // third , set end tails
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody: body];
}

-(void) appendParametersTo: (NSMutableData*)body parameters:(NSDictionary*)parameters boundary:(NSString*)boundary {
    if (!parameters || parameters.count == 0) return;
    
    NSMutableString* parameterString = [NSMutableString stringWithCapacity:0];
    for(NSString* key in parameters) {
        NSString* value = parameters[key];
        [parameterString appendFormat: @"--%@\r\nname=\"%@\"\r\n\r\n%@\r\n", boundary, key, value];
    }
    NSMutableData* parametersData = [NSMutableData dataWithData: [parameterString dataUsingEncoding: NSISOLatin2StringEncoding]];
    [body appendData: parametersData];
}


+(NSString*) randomCharactersByCount: (int)count {
    NSMutableString* result = [[NSMutableString alloc] initWithCapacity: count];
    
    for (int i=0; i<count; i++) {
        int randomNumber = Math_Random * (ASCII_Over - ASCII_Begin + 1) + ASCII_Begin;
        [result appendFormat: @"%c", randomNumber];
    }
    
    return [NSString base64Encode: result];
}

@end
