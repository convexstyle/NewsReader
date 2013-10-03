//
//  NRMacro.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

// Colors
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define SAFECOLOR(color) MIN(255,MAX(0,color))
#define CUSTOMSAFECOLOR(max, min, value) MIN(max,MAX(min,value))

// Orientation
#define ORIENTATION [[UIDevice currentDevice] orientation]

// System Version
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_MORE_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedDescending)


@interface NRMacro : NSObject

@end
