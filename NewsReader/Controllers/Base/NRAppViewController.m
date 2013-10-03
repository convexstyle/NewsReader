//
//  NRAppViewController.m
//  NewsReader
//
//  Created by convexstyle on 1/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRAppViewController.h"

@interface NRAppViewController ()

@end

@implementation NRAppViewController


#pragma mark - Orientation Related Methods
- (BOOL)shouldAutorotate
{
    if(ORIENTATION == UIDeviceOrientationPortrait ||
       ORIENTATION == UIDeviceOrientationLandscapeLeft ||
       ORIENTATION == UIDeviceOrientationLandscapeRight)
    {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#endif


#pragma mark - StatusBar
- (BOOL)prefersStatusBarHidden
{
    return NO;
}


@end
