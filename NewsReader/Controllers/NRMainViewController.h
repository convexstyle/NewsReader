//
//  NRMainViewController.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

// Category
#import "NSTimer+CFTimer.h"

// Models
#import "NRFeedData.h"

// Views
#import "NRFeedCell.h"
#import "ISRefreshControl.h"
#import "NRInitialView.h"

// Controllers
#import "NRAppViewController.h"
#import "NRWebViewController.h"

// Helpers
#import "NRFlipDelegate.h"
#import "NRNewsFeedParser.h"
#import "NRNewsFeedImageLoader.h"

@interface NRMainViewController : NRAppViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>


@end
