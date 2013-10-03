//
//  UIAlertView+CFQuick.m
//  PopCamera
//
//  Created by convexstyle on 12/08/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "UIAlertView+CFQuick.h"

void UIAlertViewQuick(NSString* title, NSString* message, NSString* dismissButtonTitle) {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:dismissButtonTitle
										  otherButtonTitles:nil
						  ] autorelease];
	[alert show];
}

@implementation UIAlertView (CFQuick)

@end
