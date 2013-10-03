//
//  NRMainViewController.m
//  NewsReader
//
//  Created by convexstyle on 30/09/13.
//  Copyright (c) 2013 convexstyle. All rights reserved.
//

#import "NRMainViewController.h"

// Class Extension
@interface NRMainViewController ()
// Private Methods
- (void)loadNewsFeed:(void(^)())aCompletionBlock;
- (void)loadNewsFeedImages;
- (void)parseNewsFeed:(NSData*)aData;
- (void)updateInitialView;
- (void)showError:(NSError*)aError;
@end

@implementation NRMainViewController {
    NRModel *_model;
    UITableView *_tableView;
    __block NRInitialView *_initialView;
    __block NRFlipDelegate *_flipDelegate;
    NSArray *_feeds;
    NRFeedCell *_heightCell;
    NSMutableDictionary *_feedQueues;
    NSMutableDictionary *_downloadQueues;
}


static NSString *const newsFeedURL = @"http://mobilatr.mob.f2.com.au/services/views/9.json";

#pragma mark - Life Circle
- (id)init
{
    self = [super init];
    if(self) {
        // Initialize
        self.title = @"";
        
        // Variables
        _model          = [NRModel getInstance];
        _feeds          = [[NSMutableArray alloc] init];
        _heightCell     = [[NRFeedCell alloc] init];
        _feedQueues     = [[NSMutableDictionary alloc] init];
        _downloadQueues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    // Remove Observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(_flipDelegate) {
        [_flipDelegate release], _flipDelegate = nil;
    }
    if(_feeds) {
        [_feeds release], _feeds = nil;
    }
    if(_heightCell) {
        [_heightCell release], _heightCell = nil;
    }
    if(_feedQueues) {
        NSArray *allQueues = [_feedQueues allValues];
        [allQueues makeObjectsPerformSelector:@selector(cancelLoading)];
        [_feedQueues removeAllObjects];
        [_feedQueues release], _feedQueues = nil;
    }
    if(_downloadQueues) {
        NSArray *allQueues = [_downloadQueues allValues];
        [allQueues makeObjectsPerformSelector:@selector(cancelLoading)];
        [_downloadQueues removeAllObjects];
        [_downloadQueues release], _downloadQueues = nil;
    }
    
    [super dealloc];
}


#pragma mark - View Circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_tableView) {
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    }
    
    // Add Observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFeedHandler:) name:NRReloadFeedData object:nil];
}

- (void)loadView
{
    // Variables
    CGRect viewRect = self.parentViewController.view.bounds;
    
    // Views
    UIView *mainView = [[UIView alloc] initWithFrame:viewRect];
    self.view        = mainView;
    [mainView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Variables
    CGRect viewRect = self.view.bounds;
    
    //--- Helpers ---//
    _flipDelegate = [[NRFlipDelegate alloc] init];
    
    
    //--- Views ---//
    // TableView
    _tableView                   = [[UITableView alloc] initWithFrame:viewRect style:UITableViewStylePlain];
    _tableView.delegate          = self;
    _tableView.dataSource        = self;
    _tableView.separatorStyle    = UITableViewCellSeparatorStyleSingleLine;
    _tableView.editing           = NO;
    _tableView.bounces           = YES;
    _tableView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.layer.transform   = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
    _tableView.layer.doubleSided = NO;
    
    // RefreshControl
    ISRefreshControl *refreshControl = [[ISRefreshControl alloc] init]; // iOS 5 Compatible RefreshControl
    [refreshControl addTarget:self action:@selector(refreshHandler:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    [refreshControl release];

    [self.view addSubview:_tableView];
    [_tableView release];
    
    // Initial View
    _initialView                        = [[NRInitialView alloc] initWithFrame:viewRect];
    _initialView.layer.doubleSided      = NO;
    _initialView.userInteractionEnabled = YES;
    [self.view addSubview:_initialView];
    [_initialView release];
    
    _flipDelegate.rootView  = self.view;
    _flipDelegate.frontView = _initialView;
    _flipDelegate.backView  = _tableView;
    
    //--- Load News Feed ---//
    [self loadNewsFeed:^{
        [_flipDelegate setCompletionBlock:^{
            [_flipDelegate release], _flipDelegate = nil;
            
            [_initialView removeFromSuperview], _initialView = nil;
        }];
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer *timer) {
            [_flipDelegate flip];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove Observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(_feedQueues) {
        NSArray *allQueues = [_feedQueues allValues];
        [allQueues makeObjectsPerformSelector:@selector(cancelLoading)];
        [_feedQueues removeAllObjects];
    }
    if(_downloadQueues) {
        NSArray *allQueues = [_downloadQueues allValues];
        [allQueues makeObjectsPerformSelector:@selector(cancelLoading)];
        [_downloadQueues removeAllObjects];
    }
}


#pragma mark - NSNotification Observer Methods
- (void)reloadFeedHandler:(NSNotification*)aNotification
{
    NSString *notificationName = aNotification.name;
    if([notificationName isEqualToString:NRReloadFeedData]) {
        
        [self loadNewsFeed:^{
            [_flipDelegate setCompletionBlock:^{
                [_flipDelegate release], _flipDelegate = nil;
                
                [_initialView removeFromSuperview], _initialView = nil;
            }];
            [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer *timer) {
                [_flipDelegate flip];
            }];
        }];
    }
}


#pragma mark - Custom View Methods
- (void)updateInitialView
{
    if(_initialView) {
        _initialView.frame = self.view.bounds;
    }
}


#pragma mark - Error Related Method
- (void)showError:(NSError*)aError
{
    if(aError) {
        NSString *errorTitle = @"Error";
        NSString *errorDesc  = @"An unknown error occurred.";
        if([aError.domain isEqualToString:NSURLErrorDomain]) {
            switch (aError.code) {
                case kCFURLErrorNotConnectedToInternet: {
                    errorDesc = @"Please check your internet connection and try again.";
                } break;
                case kCFURLErrorTimedOut: {
                    errorDesc = @"The request to the news feed was timed out. Please try later.";
                } break;
                case kCFURLErrorCannotFindHost: {
                    errorDesc = @"The url you requested was not found. Please contact an administator.";
                } break;
                case kCFURLErrorCannotConnectToHost: {
                    errorDesc = @"News Reader server is having some issues at this moment. Please try later.";
                } break;
                default: {
                } break;
            }
        } else if([aError.domain isEqualToString:NSCocoaErrorDomain]) {
            switch (aError.code) {
                case NSPropertyListReadCorruptError: {
                    errorDesc = @"Recieved data might be corrupt or invalid. Please try later.";
                } break;
                default: {
                } break;
            }
        }
        UIAlertViewQuick(errorTitle, errorDesc, @"OK");
    }
}


#pragma mark - Feed Load Related Methods
- (void)refreshHandler:(UIRefreshControl*)aRefreshControl
{
    [aRefreshControl beginRefreshing];
    
    [self loadNewsFeed:^{
        [aRefreshControl endRefreshing];
    }];
}

- (void)loadNewsFeed:(void (^)())aCompletionBlock
{
    NSTimeInterval timeStamp         = [[NSDate date] timeIntervalSince1970];
    NSNumber *loadTimestamp          = [NSNumber numberWithDouble:timeStamp];
    NRNewsFeedParser *newsFeedParser = [[NRNewsFeedParser alloc] init];
    newsFeedParser.feedUrl           = newsFeedURL;
    newsFeedParser.loadTimestamp     = loadTimestamp;
    [newsFeedParser setCompletionHandler:^(NSData *data) {
        
        // Set a ownership to this instance
        NSData *returnedData = [data retain];
        
        // Parse JSON
        [self parseNewsFeed:returnedData];
        [returnedData release], returnedData = nil;
        
        // Remove the NRNewsFeedParser instance from the feed queues.
        [_feedQueues removeObjectForKey:newsFeedParser.loadTimestamp];
        
        if(aCompletionBlock) {
            aCompletionBlock();
        }
    }];
    [newsFeedParser setFailureHandler:^(NSError *error) {
        // Show Errors
        [self showError:error];
        
        if(_initialView) {
            [_initialView showRefreshButton];
        }
    }];
    [_feedQueues setObject:newsFeedParser forKey:loadTimestamp];
    [newsFeedParser release];
    
    // Load
    [newsFeedParser load];
}

- (void)loadNewsFeedEachImageWithFeedData:(NRFeedData*)aFeedData indexPath:(NSIndexPath*)aIndexPath
{
    NRNewsFeedImageLoader *imageLoader = [[NRNewsFeedImageLoader alloc] init];// Retain
    
    if(imageLoader) {
        imageLoader.feedData  = aFeedData;
        [imageLoader setCompletionHandler:^{

            NRFeedCell *feedCell = (NRFeedCell*)[_tableView cellForRowAtIndexPath:aIndexPath];
            [feedCell setImage:imageLoader.feedData.thumbnail animate:YES];

            [_downloadQueues removeObjectForKey:aIndexPath];
        }];
        [_downloadQueues setObject:imageLoader forKey:aIndexPath];
        [imageLoader release];
        
        // Load Image
        [imageLoader load];
    }
}

- (void)loadNewsFeedImages
{
    // When feeds exist, start loading thumbnails
    if([_feeds count] > 0) {
        NSArray *visiblePaths    = [_tableView indexPathsForVisibleRows];
        NSEnumerator *enumerator = [visiblePaths objectEnumerator];
        NSIndexPath *path        = nil;
        while (path = [enumerator nextObject]) {
            NRFeedData *feedData = [_feeds objectAtIndex:path.row];
            
            // Avoid loading a thumbnail if the thumbnail url is not provided or it has been already loaded
            if(feedData.showThumbnail) {
                if(!feedData.thumbnail) {
                    [self loadNewsFeedEachImageWithFeedData:feedData indexPath:path];
                }
            }
        }
    }
}


#pragma mark - Feed Parse Related Methods
- (void)parseNewsFeed:(NSData *)aData
{
    
    if(aData) {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSError *jsonError = nil;
        NSArray *results    = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&jsonError];
        
        if(!results) {
            if(jsonError) {
                
                [_tableView reloadData];
                
                // Show Error
                [self showError:jsonError];
            }
        } else {
            
            NSString *title      = [results valueForKey:@"name"];
            NSArray *items       = [results valueForKey:@"items"];
            
            // Update Title
            self.title = title;
            
            // Check whether the feed has been updated
            if([items count] > 0) {

                // Parse news feed and update Model
                if(_feeds) {
                    [_feeds release], _feeds = nil;
                }
                [_model setFeedData:items];
                _feeds = [[_model getFeedData] retain];
                
                // Update Table
                [_tableView reloadData];
                
//                // TODO: API Specification is required.
//                // Compare the coming first feed identifier with the previous feed
//                NSDictionary *firstFeed = [items objectAtIndex:0];
//                if([_model canUpdateFeedData:firstFeed]) {
//                    // Parse news feed and update Model
//                    if(_feeds) {
//                        [_feeds release], _feeds = nil;
//                    }
//                    [_model setFeedData:items];
//                    _feeds = [[_model getFeedData] retain];
//                    // Update Table
//                    [_tableView reloadData];
//                }
                
            }
        }
        
        [pool release], pool = nil;
    }
}


#pragma mark - UITableViewDelegate Related Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NRFeedData *feedData = [_feeds objectAtIndex:indexPath.row];
    if(feedData) {
        NRWebViewController *webViewController = [[[NRWebViewController alloc] initWithTitle:feedData.headLine] autorelease];
        webViewController.feedData             = feedData;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger feedCount = [_feeds count];
    if(feedCount > 0) {
        NRFeedData *feedData          = [_feeds objectAtIndex:indexPath.row];
        _heightCell.titleLabel.text   = feedData.headLine;
        _heightCell.detailsLabel.text = feedData.slugLine;
        _heightCell.dateLabel.text    = feedData.customDate;
        _heightCell.showThumbnail     = feedData.showThumbnail;
        CGSize cellSize = [_heightCell sizeThatFits:CGSizeMake(self.view.bounds.size.width, NRTableCellMaxHeight)];// The height of table cell has to be less than 2009.
        return cellSize.height;
    }
    return NRTableCellDefaultHeight;
}


#pragma mark - UITableViewDataSource Related Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [_feeds count];
    if(count == 0) {
        return 1;
    }
    
    return [_feeds count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier            = @"feedCell";
    static NSString *placeholderIdentifier = @"placeholderCell";
    
    NSUInteger feedCount = [_feeds count];
    
    if(feedCount == 0 && indexPath.row == 0) {
        UITableViewCell *cell     = [_tableView dequeueReusableCellWithIdentifier:placeholderIdentifier];
        if(cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeholderIdentifier] autorelease];
        }
        cell.textLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"No data is available.";
        return cell;
    }
    
    NRFeedCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(feedCount > 0) {
        
        if(cell == nil) {
            cell = [[[NRFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        }
        
        NRFeedData *feedData   = [_feeds objectAtIndex:indexPath.row];
        cell.titleLabel.text   = feedData.headLine;
        cell.detailsLabel.text = feedData.slugLine;
        NSString *dateStr      = [@"posted: " uppercaseString];
        dateStr                = [dateStr stringByAppendingString:feedData.customDate];
        cell.dateLabel.text    = dateStr;
        cell.showThumbnail     = feedData.showThumbnail;
        
        if(feedData.showThumbnail) {
            if(!feedData.thumbnail) {
                [cell setImage:nil animate:NO];// Reset for iOS 5 simulator
                [self loadNewsFeedEachImageWithFeedData:feedData indexPath:indexPath];
            } else {
                // Load Cache Image
                [cell setImage:feedData.thumbnail animate:NO];
            }
        }
        
        UIView *bgView         = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView    = bgView;
        [bgView release];
        
        UIView *selectedView         = [[UIView alloc] init];
        selectedView.backgroundColor = UIColorFromRGB(0x3eabf8);
        cell.selectedBackgroundView  = selectedView;
        [selectedView release];
        
    }
    
    return cell;
}


#pragma mark - UIScrollViewDelegate Related Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate) {
        [self loadNewsFeedImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadNewsFeedImages];
}


#pragma mark - Orientation Related Methods
- (BOOL)shouldAutorotate
{
    if ( ORIENTATION == UIDeviceOrientationPortrait ||
        ORIENTATION == UIDeviceOrientationLandscapeLeft ||
        ORIENTATION == UIDeviceOrientationLandscapeRight ) {
        
        [self updateInitialView];
    }
    
    return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [super supportedInterfaceOrientations];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait ||
       interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
       interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        
        [self updateInitialView];
    }
    
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
#endif



#pragma mark - Memory Related Methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Cancel all queued image download
    if(_downloadQueues) {
        NSArray *allQueues = [_downloadQueues allValues];
        [allQueues makeObjectsPerformSelector:@selector(cancelLoading)];
        [_downloadQueues removeAllObjects];
        [_downloadQueues release], _downloadQueues = nil;
    }
}

@end
