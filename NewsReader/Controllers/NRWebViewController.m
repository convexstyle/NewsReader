//
//  NRWebViewController.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRWebViewController.h"

@interface NRWebViewController ()

@end

@implementation NRWebViewController
@synthesize feedData = _feedData;


#pragma mark - Life Circle
- (id)initWithTitle:(NSString *)aTitle
{
    self = [super init];
    if(self) {
        self.title = aTitle;
    }
    return self;
}

- (void)dealloc
{
    if(_feedData) {
        [_feedData release], _feedData = nil;
    }
    [super dealloc];
}


#pragma mark - View Circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadView
{
    // Variables
    CGRect viewRect = self.parentViewController.view.bounds;
    
    // Views
    UIView *mainView = [[UIView alloc] initWithFrame:viewRect];
    self.view        = mainView;
    [mainView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Variables
    CGRect viewRect = self.view.bounds;
    
    // Views
    UIWebView *webView       = [[UIWebView alloc] initWithFrame:viewRect];
    webView.scalesPageToFit  = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate         = self;
    webView.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:webView];
    [webView release];
    
    // Request
    NSURL *requestURL            = [NSURL URLWithString:_feedData.webHref];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request setTimeoutInterval:20];
//    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];// Ignore Cache
    [webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - UIWebViewDelegate Related Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(error) {
 
        // Show Error
        if(error.code != NSURLErrorCancelled) {// Avoid redirection
            NSString *errorTitle = @"Error";
            NSString *errorDesc  = @"An unknown error occurred.";
            if([error.domain isEqualToString:NSURLErrorDomain]) {
                switch (error.code) {
                    case kCFURLErrorNotConnectedToInternet: {
                        errorDesc = @"Please check your internet connection and try again.";
                    } break;
                    case kCFURLErrorTimedOut: {
                        errorDesc = @"The request to the news feed was timed out. Please try later.";
                    } break;
                    case kCFURLErrorCannotFindHost: {
                        errorDesc = @"The url you requested was not found. Please contact an administator.";
                    } break;
                    case kCFURLErrorCannotConnectToHost: {
                        errorDesc = @"News Reader server is having some issues at this moment. Please try later.";
                    } break;
                    default: {
                    } break;
                }
            }
            UIAlertViewQuick(errorTitle, errorDesc, @"OK");
        }
        
    }

}


#pragma mark - Orientation Related Methods
- (BOOL)shouldAutorotate
{
    return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [super supportedInterfaceOrientations];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
#endif



#pragma mark - Memory Related Methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
