//
//  NRFeedCell.h
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRFeedCell : UITableViewCell

- (void)setImage:(UIImage *)image animate:(BOOL)aAnimate;

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *detailsLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign) BOOL showThumbnail;
@end
