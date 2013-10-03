//
//  NRWebViewController.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "NRFeedData.h"

// Controllers
#import "NRAppViewController.h"

@interface NRWebViewController : NRAppViewController <UIWebViewDelegate>

- (id)initWithTitle:(NSString*)aTitle;

@property(nonatomic, strong) NRFeedData *feedData;
@end
