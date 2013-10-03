//
//  NRModel.m
//  NewsReader
//
//  Created by convexstyle on 2/10/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRModel.h"

@interface NRModel ()
@property(nonatomic, strong) NSMutableArray *data;
@end

@implementation NRModel
@synthesize data = _data;

static NRModel *sharedInstance = nil;

#pragma mark - Life Circle
//+ (id)allocWithZone:(NSZone *)zone {
//	@synchronized(self) {
//		if (!sharedInstance) {
//			sharedInstance = [super allocWithZone:zone];
//		}
//	}
//	return sharedInstance;
//}
//
//+ (NRModel*)getInstance {
//	@synchronized(self) {
//		if(!sharedInstance) {
//			[[self alloc] init];
//		}
//	}
//	return sharedInstance;
//}

+ (NRModel*)getInstance
{
    //static NRModel* sharedSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NRModel alloc] init];
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}


#pragma mark - Override NSObject methods
- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
	return self;
}


#pragma mark - Life Circle
- (BOOL)canUpdateFeedData:(NSDictionary *)aFirstFeed
{
    if(!_data || [_data count] == 0) {
        return YES;
    }
    
    if(![[_data objectAtIndex:0] isMemberOfClass:[NRFeedData class]]) {
        return YES;
    }
    
    NRFeedData *firstFeed  = [_data objectAtIndex:0];
    NSString *identifier   = [NSString stringWithFormat:@"%@", [aFirstFeed valueForKey:@"identifier"]];
    if(identifier == nil || ![identifier isEqualToString:firstFeed.identifer]) {
        return YES;
    }
    
    return NO;
}

- (void)setFeedData:(NSArray*)aFeedData
{
    if(_data) {
        [_data release], _data = nil;
    }
    _data = [[NSMutableArray alloc] init];
    
    // Parse
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];// Retain
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+10:00'"];
    
    NSEnumerator *enumerator = [aFeedData objectEnumerator];
    NSDictionary *eachFeed   = nil;
    while (eachFeed = [enumerator nextObject]) {
        
        // AutoReleasePool
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NRFeedData *feedData = [[NRFeedData alloc] init];
        
        NSString *dateLine   = [eachFeed valueForKey:@"dateLine"];
        NSString *identifier = [NSString stringWithFormat:@"%@", [eachFeed valueForKey:@"identifier"]];
        
        NSDate *inputDate                    = [inputDateFormatter dateFromString:dateLine];
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];// Retain
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *outputDateStr = [outputDateFormatter stringFromDate:inputDate];
        
        feedData.headLine           = [eachFeed valueForKey:@"headLine"];
        feedData.slugLine           = [eachFeed valueForKey:@"slugLine"];
        feedData.dateLine           = dateLine;
        feedData.identifer          = identifier;
        feedData.thumbnailImageHref = [eachFeed valueForKey:@"thumbnailImageHref"];
        feedData.tinyUrl            = [eachFeed valueForKey:@"tinyUrl"];
        feedData.webHref            = [eachFeed valueForKey:@"webHref"];
        feedData.type               = [eachFeed valueForKey:@"type"];
        feedData.customDate         = outputDateStr;
        feedData.showThumbnail      = ([feedData.thumbnailImageHref isEqual:[NSNull null]]) ? NO : YES;
        
        [_data addObject:feedData];
        [feedData release];
        
        [outputDateFormatter release], outputDateFormatter = nil;// Release
        
        // Release AutoReleasePool
        [pool release], pool = nil;
    }
    
    // Release
    [inputDateFormatter release], inputDateFormatter = nil;// Release
}

- (NSArray*)getFeedData
{
    return (NSArray*)_data;
}



@end
