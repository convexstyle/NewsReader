//
//  NRModel.h
//  NewsReader
//
//  Created by convexstyle on 2/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data Object
#import "NRFeedData.h"

@interface NRModel : NSObject

+ (NRModel*)getInstance;
- (BOOL)canUpdateFeedData:(NSDictionary*)aFirstFeed;
- (void)setFeedData:(NSArray*)aFeedData;
- (NSArray*)getFeedData;

@end
