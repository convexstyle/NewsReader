//
//  NRInitialView.m
//  NewsReader
//
//  Created by convexstyle on 1/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRInitialView.h"

@implementation NRInitialView {
    UILabel *_progressLabel;
    UIActivityIndicatorView *_indicatorView;
    UIButton *_refreshButton;
}


#pragma mark - Life Circle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialize
        self.backgroundColor = UIColorFromRGB(0x3eabf8);
        
        // Variables
        CGRect viewRect = self.bounds;
        
        //--- Views ---//
        _progressLabel                  = [[UILabel alloc] initWithFrame:viewRect];
        _progressLabel.font             = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _progressLabel.text             = [@"loading news feed" uppercaseString];
        _progressLabel.textAlignment    = UITextAlignmentCenter;
        _progressLabel.textColor        = [UIColor whiteColor];
        _progressLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _progressLabel.backgroundColor  = [UIColor clearColor];
        [self addSubview:_progressLabel];
        [_progressLabel release];
        
        _indicatorView        = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.center = CGPointMake(viewRect.size.width / 2, viewRect.size.height / 2 - _indicatorView.frame.size.height);
        [self addSubview:_indicatorView];
        [_indicatorView release];
        [_indicatorView startAnimating];
        
        UIImage *refreshImage = [UIImage imageNamed:@"RefreshButton"];
        _refreshButton        = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, refreshImage.size.width, refreshImage.size.height)];
        _refreshButton.center = _indicatorView.center;
        _refreshButton.hidden = YES;
        [_refreshButton setBackgroundImage:refreshImage forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(refreshHandler:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_refreshButton];
        [_refreshButton release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - Custom View Methods
- (void)showRefreshButton
{
    [_indicatorView stopAnimating];
    _indicatorView.hidden = YES;
    
    _refreshButton.hidden = NO;
    
    _progressLabel.text   = [@"reload news feed" uppercaseString];
}


#pragma mark - UIButton Related Methods
- (void)refreshHandler:(id)aSender
{
    if([aSender isMemberOfClass:[UIButton class]]) {
        
        [_indicatorView startAnimating];
        _indicatorView.hidden = NO;
        
        _refreshButton.hidden = YES;
        
        _progressLabel.text   = [@"loading news feed" uppercaseString];
        
        // Send Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NRReloadFeedData object:self userInfo:nil];
    }
}


#pragma mark - Override UIView Methods
- (void)layoutSubviews
{
    if(_indicatorView) {
        _indicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - _indicatorView.frame.size.height);
    }
    if(_refreshButton) {
        _refreshButton.center = _indicatorView.center;
    }
}


@end
