//
//  NSTimer+CFTimer.m
//  Object Magazine 63
//
//  Created by Hiroshi Tazawa on 10/10/12.
//  Copyright (c) 2012 Canvas Group. All rights reserved.
//

#import "NSTimer+CFTimer.h"

@implementation NSTimer (CFTimer)


+(void)timerFired:(NSTimer*)timer
{    
    if(![timer isValid]) {
        return;
    }
    
    NSTimerFiredBlock block = timer.userInfo;
    if(block) {
        block(timer);
        Block_release(block);
    }
    
}

+(NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NSTimerFiredBlock)block
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerFired:) userInfo:[block copy] repeats:repeats];
    return timer;
}

@end
