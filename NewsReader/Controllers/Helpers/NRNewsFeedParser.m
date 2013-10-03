//
//  NRNewsFeedParser.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRNewsFeedParser.h"

@implementation NRNewsFeedParser {
    NSURLConnection *_connection;
}
@synthesize feedUrl       = _feedUrl;
@synthesize downloadData  = _downloadData;
@synthesize loadTimestamp = _loadTimestamp;


#pragma mark - Life Circle
- (id)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)dealloc
{
    if(_feedUrl) {
        [_feedUrl release], _feedUrl = nil;
    }
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    if(self.completionHandler) {
        Block_release(self.completionHandler);
    }
    if(self.failureHandler) {
        Block_release(self.failureHandler);
    }
    if(_loadTimestamp) {
        [_loadTimestamp release], _loadTimestamp = nil;
    }
    if(_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
        
        [self release];
    }

    [super dealloc];
}


#pragma mark - Load a feed JSON file
- (void)load
{
    // validate required parameters
    if(_feedUrl == nil) {
        return;
    }
    
    //--- Request ---//
    if(_downloadData) {
        [_downloadData release], _downloadData = nil;
    }
    _downloadData = [[NSMutableData alloc] init];
    
    NSURL *requestURL     = [NSURL URLWithString:_feedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    _connection           = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_connection start];
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
    // Call Block
    if(self.completionHandler) {
        self.completionHandler(_downloadData);
        
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
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
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
    
    // Call Block
    if(self.failureHandler) {
        self.failureHandler(error);
    }
}


@end
