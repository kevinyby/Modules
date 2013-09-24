#import "HTTPRequestBase.h"

@implementation HTTPRequestBase

@synthesize delegate;

@synthesize requestID;

- (id)init {
    [self dealloc];
    @throw [NSException exceptionWithName:@"Reject Exception"
                                   reason:@"Invoke initWithURLString:parameters: instead "
                                 userInfo:nil];
    return nil;
}

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters {
    self = [super init];
    
    if (self) {
        NSMutableURLRequest* request = [self getURLRequest: urlString parameters:parameters];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        self.requestID = [NSString stringWithFormat: @"%p", self];
        
        receiveData = [[NSMutableData alloc] initWithCapacity:0];
    }
    
    return self;
}

-(void) startRequest {
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [connection start];
}

- (void)dealloc
{
    [connection release];
    [receiveData release];
    [super dealloc];
}

#pragma mark - SubClass Overwrite Methods
-(NSMutableURLRequest*) getURLRequest: (NSString*)urlString parameters:(NSDictionary*)parameters {
    return nil;
}


#pragma mark - NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (delegate && [delegate respondsToSelector: @selector(didFailPostWithError:error:)] ) {
        [delegate didFailPostWithError: self error:error];
    }
}

#pragma mark - NSURLConnectionDataDelegate Methods
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (delegate && [delegate respondsToSelector: @selector(didSucceedPost:response:)] ) {
        [delegate didSucceedPost: self response:response];
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
