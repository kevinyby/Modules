/*
 *
 * A wrapper of HTTP Post Request
 * When initial , URL String and parameters(can be null) is needed
 * Delegate is needed if you need the response header and data .
 *
 */

#import <Foundation/Foundation.h>

#define NetworkTimeOutInterval 25

@protocol HTTPRequestDelegate;

@interface HTTPRequestBase : NSObject <NSURLConnectionDataDelegate> {
    @private
    NSMutableData* receiveData;
    NSURLConnection* urlconnection;
}

@property (assign) id<HTTPRequestDelegate> delegate;

@property (retain) NSString* requestID ;

-(id) initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters ;
-(void) startRequest ;

#pragma mark - SubClass Overwrite Methods
-(NSMutableURLRequest*) getURLRequest: (NSString*)urlString parameters:(NSDictionary*)parameters ;

@end


@protocol HTTPRequestDelegate <NSObject>

@optional

-(void) didFailRequestWithError: (HTTPRequestBase*)request error:(NSError*)error ;
-(void) didSucceedRequest: (HTTPRequestBase*)request response:(NSHTTPURLResponse*)response;
-(void) didReceiveData: (HTTPRequestBase*)request data:(NSData*)data ;
-(void) didFinishReceiveData: (HTTPRequestBase*)request data:(NSData*)data;

@end
