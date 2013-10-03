//
//  NRFlipDelegate.m
//  NewsReader
//
//  Created by convexstyle on 1/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRFlipDelegate.h"

@implementation NRFlipDelegate
@synthesize rootView  = _rootView;
@synthesize backView  = _backView;
@synthesize frontView = _frontView;


#pragma mark - Life Circle
- (id)init
{
    self = [super init];
    if(self) {
    }
    return self;
}

- (void)dealloc
{
    if(self.completionBlock) {
        Block_release(self.completionBlock);
    }
    
    [super dealloc];
}


#pragma mark - Core Animation Method
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *frontViewLayer = _frontView.layer;
    CALayer *backViewLayer  = _backView.layer;
    
    if(anim == [frontViewLayer animationForKey:NRFlipAnimationKey]) {
        
        frontViewLayer.zPosition = 0;
        backViewLayer.zPosition = 100;
        [_rootView sendSubviewToBack:_backView];
        
        // Call Completion Block
        if(self.completionBlock) {
            self.completionBlock();
        }
        
    }
}


#pragma mark - Flip Method
- (void)flip
{
    CALayer *frontViewLayer = _frontView.layer;
    CALayer *backViewLayer  = _backView.layer;
    
    frontViewLayer.zPosition = 100;
    
    [self transform3DLayer:frontViewLayer duration:1.0f functionName:kCAMediaTimingFunctionEaseInEaseOut autoreverse:NO removedOnCompletion:NO delegate:YES angle:-M_PI ax:0.0f ay:1.0f az:0.0f animationKey:NRFlipAnimationKey];
    
    [self transform3DLayer:backViewLayer duration:1.0f functionName:kCAMediaTimingFunctionEaseInEaseOut autoreverse:NO removedOnCompletion:YES delegate:NO angle:-M_PI ax:0.0f ay:1.0f az:0.0f animationKey:nil];
}


#pragma mark - Flip Utility Method
- (void)transform3DLayer:(CALayer*)layer
                duration:(CFTimeInterval)duration
            functionName:(NSString*)functionName
             autoreverse:(BOOL)autoreverse
     removedOnCompletion:(BOOL)removedOnCompletion
                delegate:(BOOL)delegate
                   angle:(CGFloat)angle
                      ax:(CGFloat)ax
                      ay:(CGFloat)ay
                      az:(CGFloat)az
            animationKey:(NSString*)animationKey
{
    // Rotation Animation (Transform 3D)
    CATransform3D rTransform     = layer.transform;
    rTransform.m34               = 1.0f / 5000.0f;
    CATransform3D rNextTransform = CATransform3DRotate(rTransform, angle, ax, ay, az);
    
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setFromValue:[NSValue valueWithCATransform3D:rTransform]];
    [animation setToValue:[NSValue valueWithCATransform3D:rNextTransform]];
    [animation setBeginTime:0.0f];
    [animation setDuration:duration];
    
    // Scale Animation 1
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[NSNumber numberWithFloat:1.0f]];
    [scaleAnimation setToValue:[NSNumber numberWithFloat:0.75f]];
    [scaleAnimation setBeginTime:0.0f];
    [scaleAnimation setDuration:duration/2];
    
    // Scale Animation 2
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation2 setFromValue:[NSNumber numberWithFloat:0.75f]];
    [scaleAnimation2 setToValue:[NSNumber numberWithFloat:1.0f]];
    [scaleAnimation2 setBeginTime:duration/2];
    [scaleAnimation2 setDuration:duration/2];
    
    CAAnimationGroup *group   = [CAAnimationGroup animation];
    group.duration            = duration;
    group.timingFunction      = [CAMediaTimingFunction functionWithName:functionName];
    group.autoreverses        = NO;
    group.removedOnCompletion = removedOnCompletion;
    if(delegate)
        group.delegate = self;
    [group setAnimations:[NSArray arrayWithObjects:animation, scaleAnimation, scaleAnimation2, nil]];
    [layer setTransform:rNextTransform];
    [layer addAnimation:group forKey:animationKey];
}


@end
