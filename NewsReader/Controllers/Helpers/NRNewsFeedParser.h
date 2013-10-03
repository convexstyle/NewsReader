//
//  NRNewsFeedParser.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NRNewsFeedParser : NSObject <NSURLConnectionDataDelegate>

- (void)load;
- (void)cancelLoading;

@property (nonatomic, strong) NSString *feedUrl;
@property (nonatomic, strong) NSMutableData *downloadData;
@property (nonatomic, copy) void(^completionHandler)(NSData *data);
@property (nonatomic, copy) void(^failureHandler)(NSError *error);
@property (nonatomic, strong) NSNumber *loadTimestamp;
@end
