#import "HTTPRequestBase.h"

#define NetworkTimeOutInterval 20

@implementation HTTPRequestBase
{
    NSURLConnection* urlconnection;
    
    void(^completeHandlerBlock)(HTTPRequestBase* httpRequest, NSURLResponse* response, NSData* data, NSError* connectionError);
    
    NSMutableData* connectionReceivedData;
    NSURLResponse* connectionResponse;
    NSError* connectionError;
}

@synthesize delegate;

@synthesize request;
@synthesize identification;

- (id)init {
    @throw [NSException exceptionWithName:@"Reject Exception"
                                   reason:@"Invoke initWithURLString:parameters: instead "
                                 userInfo:nil];
    return nil;
}

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters {
    return [self initWithURLString:urlString parameters:parameters timeoutInterval:NetworkTimeOutInterval];
}

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters timeoutInterval:(NSTimeInterval)timeoutInterval {
    self = [super init];
    
    if (self) {
        
        NSURL* url = [self getURL: urlString parameters:parameters];
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval] ;
        [self applyRequest: urlRequest parameters:parameters];
        request = urlRequest;
        
        identification = [NSString stringWithFormat: @"%p", self];  // default
        
        connectionReceivedData = [[NSMutableData alloc] initWithCapacity:0];
    }
    
    return self;
}

-(void) startRequest: (void (^)(HTTPRequestBase* httpRequest, NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler {
    completeHandlerBlock = completeHandler;
    [self startRequest];
}

-(void) startRequest {
    NSRunLoop* loop = [NSRunLoop currentRunLoop];
    urlconnection = [[NSURLConnection alloc] initWithRequest: self.request delegate:self startImmediately:NO];
    [urlconnection scheduleInRunLoop:loop forMode:NSRunLoopCommonModes];
    [urlconnection start];
//    [loop run];           //If you want the run loop to terminate, you shouldn't use this method. See the docs
}

-(void) cancelRequest {
    [urlconnection cancel];
}

// this one can not be cancel using [operationQueue cancelAllOperations]
-(void) startAsynchronousRequest: (void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler {
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest: request queue:operationQueue completionHandler:completeHandler];
}



#pragma mark - SubClass Optional Overwrite Methods

-(NSURL*) getURL: (NSString*)urlString parameters:(NSDictionary*)parameters {
    NSString* encodeURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString: encodeURL];
}



#pragma mark - SubClass Required Overwrite Methods

-(void) applyRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters {}




#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    connectionError = error;
    
    // delegate
    if (completeHandlerBlock) {
        completeHandlerBlock(self , nil, nil, connectionError);
    }
    
    else
    
    if (delegate && [delegate respondsToSelector: @selector(didFailRequestWithError:error:)] ) {
        [delegate didFailRequestWithError: self error:error];
    }
}



#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    connectionResponse = response;
    
    // Note here :  statusCode >= 400 , we regard it as request fail
    NSHTTPURLResponse* httpURLReqponse = (NSHTTPURLResponse*) response;
    NSInteger statusCode = [httpURLReqponse statusCode];
    if( statusCode >= 400) {
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary: [httpURLReqponse allHeaderFields]];
        NSString* suggestedFilename = httpURLReqponse.suggestedFilename;
        NSString* mimetype = httpURLReqponse.MIMEType;
        [userInfo setObject: suggestedFilename forKey:@"suggestedFilename"];
        [userInfo setObject: mimetype forKey:@"mimetype"];
        [userInfo setObject: [NSNumber numberWithInt: statusCode] forKey:@"statusCode"];
        [self connection: connection didFailWithError: [NSError errorWithDomain: httpURLReqponse.URL.host code:statusCode userInfo:userInfo]];
    }
    
    // delegate
    if (delegate && [delegate respondsToSelector: @selector(didSucceedRequest:response:)] ) {
        [delegate didSucceedRequest: self response:httpURLReqponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [connectionReceivedData appendData: data];
    
    // delegate
    if (delegate && [delegate respondsToSelector: @selector(didReceivePieceData:data:)] ) {
        [delegate didReceivePieceData: self data:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (completeHandlerBlock) {
        completeHandlerBlock(self, connectionResponse, connectionReceivedData, connectionError);
    }
    
    else
        
    if (delegate && [delegate respondsToSelector: @selector(didFinishReceiveData:data:)]) {
        [delegate didFinishReceiveData: self data:connectionReceivedData];
    }
}

@end
