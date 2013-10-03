//
//  NRFeedData.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRFeedData : NSObject

@property(nonatomic, strong) NSString *headLine;
@property(nonatomic, strong) NSString *slugLine;
@property(nonatomic, strong) NSString *dateLine;
@property(nonatomic, strong) NSString *identifer;
@property(nonatomic, strong) NSString *thumbnailImageHref;
@property(nonatomic, strong) NSString *tinyUrl;
@property(nonatomic, strong) NSString *webHref;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *customDate;
@property(nonatomic, strong) UIImage *thumbnail;
@property(nonatomic, assign) BOOL showThumbnail;
@end
