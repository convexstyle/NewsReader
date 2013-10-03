//
//  NRAppDelegate.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRAppDelegate.h"

@implementation NRAppDelegate {
    NRModel *_model;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //--- UIAppearance ---//
    // NavigationBar
    UIImage *nav44BgImage   = [[UIImage imageNamed:@"NavigationBar_Bg_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *nav32BgImage   = [[UIImage imageNamed:@"NavigationBar_Bg_32"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:nav44BgImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:nav32BgImage forBarMetrics:UIBarMetricsLandscapePhone];
    
    NSDictionary *navParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIColor blackColor], UITextAttributeTextColor,
//                               [UIFont fontWithName:@"HelveticaNeue-Bold" size:0], UITextAttributeFont,
                               [UIColor clearColor], UITextAttributeTextShadowColor,
                               [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                               nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navParams];
    
    // UIBarButtonItem
    NSDictionary *barButtonParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                    UIColorFromRGB(0x007aff), UITextAttributeTextColor,
                                    [UIFont fontWithName:@"HelveticaNeue-Bold" size:0], UITextAttributeFont,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonParams forState:UIControlStateNormal];
    
    if(SYSTEM_VERSION_LESS_THAN(@"7")) {
        UIImage *backNormal30Image = [[UIImage imageNamed:@"UIBarButtonItem_BackNormal_30"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 3)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backNormal30Image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        UIImage *backNormal24Image = [[UIImage imageNamed:@"UIBarButtonItem_BackNormal_24"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 3)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backNormal24Image forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    }
    
    // UIRefreshControl
//    [[UIRefreshControl appearance] setTintColor:UIColorFromRGB(0x3eabf8)];
    
    //--- Model ---//
    _model = [NRModel getInstance];
    
    //--- Controllers ---//
    NRMainViewController *mainViewController = [[NRMainViewController alloc] init];
    NRNavViewController *navController       = [[NRNavViewController alloc] initWithRootViewController:mainViewController];
    [mainViewController release];
    
    [_window setRootViewController:navController];
    [navController release];
    
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    if(_window) {
        [_window release], _window = nil;
    }
    if(_model) {
        [_model release], _model = nil;
    }
    
    [super dealloc];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
