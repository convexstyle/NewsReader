//
//  NRNewsFeedImageLoader.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRNewsFeedImageLoader.h"


@implementation NRNewsFeedImageLoader {
    NSURLConnection *_connection;
    NSMutableData *_downloadData;
}
@synthesize feedData  = _feedData;


#pragma mark - Life Circle
- (id)init
{
    self = [super init];
    if(self) {
        // Variables
    }
    return self;
}

- (void)dealloc
{
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    if(_feedData) {
        [_feedData release], _feedData = nil;
    }
    if(self.completionHandler) {
        Block_release(self.completionHandler);
    }
    if(_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
        
        // Release self because of delegation
        [self release];
    }
    [super dealloc];
}


#pragma mark - Load Methods
- (void)load
{
    if(!_feedData) {
        return;
    }
    
    //--- Request ---//
    // Just in case, release objects
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    _downloadData = [[NSMutableData alloc] init];
    
    NSURL *requestURL     = [NSURL URLWithString:_feedData.thumbnailImageHref];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    _connection           = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelLoading
{
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    if(_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
        
        // Release self because of delegation
        [self release];
    }
}


#pragma mark - NSURLConnectionDataDelegate Related Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _feedData.thumbnail = [UIImage imageWithData:_downloadData];
    
    // Release objects
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    if(_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
        
        // Release self because of delegation
        [self release];
    }
    
    // Call Success Block
    if(self.completionHandler)
        self.completionHandler();
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release objects
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    if(_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
        
        // Release self because of delegation
        [self release];
    }
}


@end
