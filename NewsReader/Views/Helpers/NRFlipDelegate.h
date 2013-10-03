//
//  NRFlipDelegate.h
//  NewsReader
//
//  Created by convexstyle on 1/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NRFlipDelegate : NSObject

- (void)flip;

@property(nonatomic, assign) UIView *rootView;
@property(nonatomic, assign) UIView *frontView;
@property(nonatomic, assign) UIView *backView;
@property(nonatomic, copy) void(^completionBlock)(void);
@end
