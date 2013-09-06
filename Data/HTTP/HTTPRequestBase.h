/*
 *
 * A wrapper of HTTP Post Request
 * When initial , URL String and parameters(can be null) is needed
 * Delegate is needed if you need the response header and data .
 *
 */

#import <Foundation/Foundation.h>

#define NetworkTimeOutInterval 25

@protocol IEPostRequestDelegate;

@interface HTTPRequestBase : NSObject <NSURLConnectionDataDelegate> {
    NSURLConnection* connection;
}

@property (assign) id<IEPostRequestDelegate> delegate;

@property (assign) int requestId ;

-(id)initWithURLString: (NSString*)urlString parameters:(NSDictionary*)parameters ;
-(void) startRequest ;

#pragma mark - SubClass Overwrite Methods
-(NSMutableURLRequest*) getURLRequest: (NSString*)urlString parameters:(NSDictionary*)parameters ;

@end


@protocol IEPostRequestDelegate <NSObject>

@optional

-(void) didFailPostWithError: (HTTPRequestBase*)request error:(NSError*)error ;
-(void) didSucceedPost: (HTTPRequestBase*)request response:(NSURLResponse*)response;
-(void) didReceiveData: (HTTPRequestBase*)request data:(NSData*)data ;
-(void) didFinishReceiveData: (HTTPRequestBase*)request;

@end
