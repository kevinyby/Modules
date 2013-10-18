#import "HTTPRequestBase.h"

#define NetworkTimeOutInterval 30

@interface HTTPRequestBase ()

@property (strong) NSURLRequest* request;

@end

@implementation HTTPRequestBase

@synthesize delegate;

@synthesize request;
@synthesize requestID;

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
        self.request = urlRequest;
        
        urlconnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
        self.requestID = [NSString stringWithFormat: @"%p", self];
        
        receiveData = [[NSMutableData alloc] initWithCapacity:0];
    }
    
    return self;
}

-(void) startRequest {
    [urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlconnection start];
}

-(void) startRequest: (void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completeHandler {
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest: request queue:queue completionHandler:completeHandler];
}


#pragma mark - SubClass Optional Overwrite Methods
-(NSURL*) getURL: (NSString*)urlString parameters:(NSDictionary*)parameters {
    return [NSURL URLWithString: urlString];
}

#pragma mark - SubClass Required Overwrite Methods
-(void) applyRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters {}




#pragma mark - NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (delegate && [delegate respondsToSelector: @selector(didFailRequestWithError:error:)] ) {
        [delegate didFailRequestWithError: self error:error];
    }
}

#pragma mark - NSURLConnectionDataDelegate Methods
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
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
    
    if (delegate && [delegate respondsToSelector: @selector(didSucceedRequest:response:)] ) {
        [delegate didSucceedRequest: self response:httpURLReqponse];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receiveData appendData: data];
    if (delegate && [delegate respondsToSelector: @selector(didReceiveData:data:)] ) {
        [delegate didReceiveData: self data:data];
    }
}

//- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request {}

//- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {}

//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (delegate && [delegate respondsToSelector: @selector(didFinishReceiveData:data:)]) {
        [delegate didFinishReceiveData: self data:receiveData];
    }
}

@end
