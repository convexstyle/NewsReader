//
//  NRFeedData.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRFeedData.h"

@implementation NRFeedData
@synthesize headLine           = _headLine;
@synthesize slugLine           = _slugLine;
@synthesize dateLine           = _dateLine;
@synthesize identifer          = _identifer;
@synthesize thumbnailImageHref = _thumbnailImageHref;
@synthesize tinyUrl            = _tinyUrl;
@synthesize webHref            = _webHref;
@synthesize type               = _type;
@synthesize customDate         = _customDate;
@synthesize thumbnail          = _thumbnail;
@synthesize showThumbnail      = _showThumbnail;

- (void)dealloc
{
    if(_headLine) {
        [_headLine release], _headLine = nil;
    }
    if(_slugLine) {
        [_slugLine release], _slugLine = nil;
    }
    if(_dateLine) {
        [_dateLine release], _dateLine = nil;
    }
    if(_identifer) {
        [_identifer release], _identifer = nil;
    }
    if(_thumbnailImageHref) {
        [_thumbnailImageHref release], _thumbnailImageHref = nil;
    }
    if(_tinyUrl) {
        [_tinyUrl release], _tinyUrl = nil;
    }
    if(_webHref) {
        [_webHref release], _webHref = nil;
    }
    if(_type) {
        [_type release], _type = nil;
    }
    if(_customDate) {
        [_customDate release], _customDate = nil;
    }
    if(_thumbnail) {
        [_thumbnail release], _thumbnail = nil;
    }
    [super dealloc];
}

@end
