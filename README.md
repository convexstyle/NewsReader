## News Reader

This is a sample application that shows the news feed of [The Sydney Morning Herald](http://www.smh.com.au/).


### Guidelines

* on-ARC (manual reference counting)
* No storyboard
* No thread program was used


---------------------------------------


### Deployment Target
* iOS 5

*In terms of iOS 5, I currently don't have any device which had iOS 5 installed so that I tested News Reader in iOS 5 Simulator.*


---------------------------------------


### Tested Device and Simulator
* iOS 5 Simulator
* iPhone 3GS
* iPhone 4
* iPhone 4S
* iPod 4
* iPhone 5
* iPod 5
* iPhone 5s
* iPhone 5c


---------------------------------------


### Ingests a json feed

1. Load a json feed asynchoronously by using NSURLConnection and NSURLRequest in a NRNewsFeedParser object.
2. Convert a NSData to a JSON object by using NSJSONSerialization. 
3. Delegate the parsing of the JSON object to NRModel and store each feed as a Data Object (NRFeedData) in an NSArray.
3. Add a UIRefreshControl (ISRefreshControl libary for iOS 5) to refesh the feed. To avoid overwriting the request, I stored the NRNewsFeedParser instance in the NSArray and removed it once the request has been complete.


---------------------------------------


##### Issues to struggle:
I got the following warning in the console.
<pre>
ADDRESPONSE - ADDING TO MEMORY ONLY: http://mobilatr.mob.f2.com.au/services/views/9.json
</pre>
To solve this, I explicitly set the caching role and time out by requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval method.


---------------------------------------


### Displays the content in a UITableView

1. Add 4 view elements (titleLabel, detailsLabel, imageView, dateLabel) to a custom UITableViewCell class (NRFeedCell).
2. To achieve the dynamic height according to the contents of each feed, I overwrote layoutSubviews and sizeThatFits:(CGSize)size in the custom NRFeedCell and prepared a reusable NRFeedCell instance in the main viewController to calculate the height of each row in tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath.
3. Not to show unprovided images, I added the Boolean property showThumbnail in NRFeedData so that when the thumbnailImageHref value is null, it is set to false.


---------------------------------------


### Loads the images lazily

1. Handle UIScrollViewDelegate methods from UITableView.
2. Get NSIndexPath values of the visible rows by using indexPathsForVisibleRows and retrieve each row object (NRFeedData) according to the row value.
3. Start loading a thumbnail by using NRNewsFeedImageLoader object. Once the thumbnail is loaded, it is retained (cached) in the NRFeedData object so that it is no longer loaded later.

##### It can be done
Instead of loading a low-res image, the high-res version of the image can be loaded for Retina display.
http://images.smh.com.au/2013/10/02/4795935/John%20Hopkins.-90x60.jpg (low-res)
http://images.smh.com.au/2013/10/02/4795935/John%20Hopkins.-180x120.jpg (high-res)


---------------------------------------


### When clicking on a cell

1. Get the selected NSIndexPath row and retrieve the related NRFeedData object. 
2. Retain the NRFeedData object in NRWebViewController and push it to the visible UIViewController instance.
3. Retrieve the webHref value from the retained NRFeedData object and open the page in UIWebView.


---------------------------------------


### Orientation Support

1. Add autoresizingMask (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) to UITableView and UIWebView so that they are resized according to the change of orientation.
