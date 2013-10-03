//
//  NRNavViewController.m
//  NewsReader
//
//  Created by convexstyle on 1/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRNavViewController.h"

@interface NRNavViewController ()

@end

@implementation NRNavViewController

#pragma mark - Orientation Related Methods
- (BOOL)shouldAutorotate
{
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
    return [self.visibleViewController supportedInterfaceOrientations];
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.visibleViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#endif


#pragma mark - Memory Related Methods
- (void)didReceiveMemoryWarning
{
    [self.visibleViewController didReceiveMemoryWarning];
    
    [super didReceiveMemoryWarning];
}


@end
