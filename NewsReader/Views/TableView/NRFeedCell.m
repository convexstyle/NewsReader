//
//  NRFeedCell.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRFeedCell.h"

@interface NRFeedCell ()
@end

@implementation NRFeedCell
@synthesize titleLabel    = _titleLabel;
@synthesize detailsLabel  = _detailsLabel;
@synthesize dateLabel     = _dateLabel;
@synthesize imageView     = _imageView;
@synthesize showThumbnail = _showThumbnail;


#pragma mark - Life Circle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //--- Views ---//
        _titleLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
        [self addSubview:_titleLabel];
        [_titleLabel release];
        
        _detailsLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailsLabel.lineBreakMode = UILineBreakModeWordWrap;
        _detailsLabel.numberOfLines = 0;
        _detailsLabel.font          = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        [self addSubview:_detailsLabel];
        [_detailsLabel release];
        
        _imageView        = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.hidden = YES;
        _imageView.image  = nil;
        [_imageView.layer setBorderColor:UIColorFromRGB(0xe4e6e8).CGColor];
        [_imageView.layer setBorderWidth:1.0f];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView release];
        
        _dateLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.lineBreakMode = UILineBreakModeWordWrap;
        _dateLabel.numberOfLines = 0;
        _dateLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Italic" size:12.0f];
        [self addSubview:_dateLabel];
        [_dateLabel release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - Custom View Methods
- (void)setImage:(UIImage *)image animate:(BOOL)aAnimate
{
    if(aAnimate) {
        
        [UIView transitionWithView:self
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
                        animations:^{
                            _imageView.image = image;
                        } completion:nil];
        
    } else {
        _imageView.image = image;
    }
}


#pragma mark - Override UIView Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // TitleLabel
    [self sizeThatFits:self.bounds.size];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    //--- Variables ---//
    CGFloat maxWidth = size.width - NRTableCellPaddingLeft - NRTableCellPaddingRight;
    
    //--- Views ---//
    // Title Label
    _titleLabel.frame = CGRectMake(NRTableCellPaddingLeft, NRTableCellPaddingTop, maxWidth, 0);
    [_titleLabel sizeToFit];
    CGRect titleFrame = _titleLabel.frame;
    
    // Detail Label
    CGRect detailFrame;
    if(_showThumbnail) {
        _detailsLabel.frame = CGRectMake(titleFrame.origin.x, titleFrame.origin.y + titleFrame.size.height + NRTableCellPaddingTop, maxWidth - NRFeedThumbnailSize.width - NRTableCellPaddingLeft, 0);
        [_detailsLabel sizeToFit];
        detailFrame = _detailsLabel.frame;
    } else {
        _detailsLabel.frame = CGRectMake(titleFrame.origin.x, titleFrame.origin.y + titleFrame.size.height + NRTableCellPaddingTop, maxWidth, 0);
        [_detailsLabel sizeToFit];
        detailFrame = _detailsLabel.frame;
    }
    
    // Image View
    if(_showThumbnail) {
        if(detailFrame.size.height < NRFeedThumbnailSize.height) {
            detailFrame.size.height = NRFeedThumbnailSize.height;
        }
        _imageView.hidden = NO;
        _imageView.frame = CGRectMake(size.width - NRTableCellPaddingRight - NRFeedThumbnailSize.width,
                                      detailFrame.origin.y,
                                      NRFeedThumbnailSize.width,
                                      NRFeedThumbnailSize.height);
    } else {
        _imageView.hidden = YES;
    }
    
    // Date Label
    _dateLabel.frame = CGRectMake(detailFrame.origin.x, detailFrame.origin.y + detailFrame.size.height + NRTableCellPaddingTop, maxWidth, 0);
    [_dateLabel sizeToFit];
    CGRect dateFrame = _dateLabel.frame;
    
    CGFloat finalHeight = dateFrame.origin.y + dateFrame.size.height + NRTableCellPaddingBottom;
    finalHeight         = fminf(size.height, finalHeight);
    CGSize finalSize    = CGSizeMake(size.width, finalHeight);
    
    
    return finalSize;
}


@end
