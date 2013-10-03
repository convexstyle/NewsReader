//
//  NRNewsFeedImageLoader.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models
#import "NRFeedData.h"

@interface NRNewsFeedImageLoader : NSObject <NSURLConnectionDataDelegate>

- (void)load;
- (void)cancelLoading;

@property(nonatomic, strong) NRFeedData *feedData;
@property(nonatomic, copy) void(^completionHandler)(void);
@end
