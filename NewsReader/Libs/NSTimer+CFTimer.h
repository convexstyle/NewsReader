//
//  NSTimer+CFTimer.h
//  Object Magazine 63
//
//  Created by Hiroshi Tazawa on 10/10/12.
//  Copyright (c) 2012 Canvas Group. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NSTimerFiredBlock)(NSTimer *timer);

@interface NSTimer (CFTimer)

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(NSTimerFiredBlock)block;

@end
