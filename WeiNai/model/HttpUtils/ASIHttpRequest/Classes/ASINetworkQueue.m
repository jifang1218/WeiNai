//
//  EMASINetworkQueue.m
//  Part of EMASIHTTPRequest -> http://allseeing-i.com/EMASIHTTPRequest
//
//  Created by Ben Copsey on 07/11/2008.
//  Copyright 2008-2009 All-Seeing Interactive. All rights reserved.
//

#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

// Private stuff
@interface EMASINetworkQueue ()
	- (void)resetProgressDelegate:(id *)progressDelegate;
	@property (assign) int requestsCount;
@end

@implementation EMASINetworkQueue

- (id)init
{
	self = [super init];
	[self setShouldCancelAllRequestsOnFailure:YES];
	[self setMaxConcurrentOperationCount:4];
	[self setSuspended:YES];
	
	return self;
}

+ (id)queue
{
	return [[[self alloc] init] autorelease];
}

- (void)dealloc
{
	//We need to clear the queue on any requests that haven't got around to cleaning up yet, as otherwise they'll try to let us know if something goes wrong, and we'll be long gone by then
	for (EMASIHTTPRequest *request in [self operations]) {
		[request setQueue:nil];
	}
	[userInfo release];
	[super dealloc];
}

- (void)setSuspended:(BOOL)suspend
{
	[super setSuspended:suspend];
}

- (void)reset
{
	[self cancelAllOperations];
	[self setDelegate:nil];
	[self setDownloadProgressDelegate:nil];
	[self setUploadProgressDelegate:nil];
	[self setRequestDidStartSelector:NULL];
	[self setRequestDidReceiveResponseHeadersSelector:NULL];
	[self setRequestDidFailSelector:NULL];
	[self setRequestDidFinishSelector:NULL];
	[self setQueueDidFinishSelector:NULL];
	[self setSuspended:YES];
}


- (void)go
{
	[self setSuspended:NO];
}

- (void)cancelAllOperations
{
	[self setBytesUploadedSoFar:0];
	[self setTotalBytesToUpload:0];
	[self setBytesDownloadedSoFar:0];
	[self setTotalBytesToDownload:0];
	[super cancelAllOperations];
}

- (void)setUploadProgressDelegate:(id)newDelegate
{
	uploadProgressDelegate = newDelegate;
	[self resetProgressDelegate:&uploadProgressDelegate];

}

- (void)setDownloadProgressDelegate:(id)newDelegate
{
	downloadProgressDelegate = newDelegate;
	[self resetProgressDelegate:&downloadProgressDelegate];
}

- (void)resetProgressDelegate:(id *)progressDelegate
{
#if !TARGET_OS_IPHONE
	// If the uploadProgressDelegate is an NSProgressIndicator, we set its MaxValue to 1.0 so we can treat it similarly to UIProgressViews
	SEL selector = @selector(setMaxValue:);
	if ([*progressDelegate respondsToSelector:selector]) {
		double max = 1.0;
		[EMASIHTTPRequest performSelector:selector onTarget:progressDelegate withObject:nil amount:&max callerToRetain:nil];
	}
	selector = @selector(setDoubleValue:);
	if ([*progressDelegate respondsToSelector:selector]) {
		double value = 0.0;
		[EMASIHTTPRequest performSelector:selector onTarget:progressDelegate withObject:nil amount:&value callerToRetain:nil];
	}
#else
	SEL selector = @selector(setProgress:);
	if ([*progressDelegate respondsToSelector:selector]) {
		float value = 0.0f;
		[EMASIHTTPRequest performSelector:selector onTarget:progressDelegate withObject:nil amount:&value callerToRetain:nil];
	}
#endif
}

- (void)addHEADOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[EMASIHTTPRequest class]]) {
		
		EMASIHTTPRequest *request = (EMASIHTTPRequest *)operation;
		[request setRequestMethod:@"HEAD"];
		[request setQueuePriority:10];
		[request setShowAccurateProgress:YES];
		[request setQueue:self];
		
		// Important - we are calling NSOperation's add method - we don't want to add this as a normal request!
		[super addOperation:request];
	}
}

// Only add ASIHTTPRequests to this queue!!
- (void)addOperation:(NSOperation *)operation
{
	if (![operation isKindOfClass:[EMASIHTTPRequest class]]) {
		[NSException raise:@"AttemptToAddInvalidRequest" format:@"Attempted to add an object that was not an EMASIHTTPRequest to an EMASINetworkQueue"];
	}
		
	[self setRequestsCount:[self requestsCount]+1];
	
	EMASIHTTPRequest *request = (EMASIHTTPRequest *)operation;
	
	if ([self showAccurateProgress]) {
		
		// Force the request to build its body (this may change requestMethod)
		[request buildPostBody];
		
		// If this is a GET request and we want accurate progress, perform a HEAD request first to get the content-length
		// We'll only do this before the queue is started
		// If requests are added after the queue is started they will probably move the overall progress backwards anyway, so there's no value performing the HEAD requests first
		// Instead, they'll update the total progress if and when they receive a content-length header
		if ([[request requestMethod] isEqualToString:@"GET"]) {
			if ([self isSuspended]) {
				EMASIHTTPRequest *HEADRequest = [request HEADRequest];
				[self addHEADOperation:HEADRequest];
				[request addDependency:HEADRequest];
				if ([request shouldResetDownloadProgress]) {
					[self resetProgressDelegate:&downloadProgressDelegate];
					[request setShouldResetDownloadProgress:NO];
				}
			}
		}
		[request buildPostBody];
		[self request:nil incrementUploadSizeBy:[request postLength]];


	} else {
		[self request:nil incrementDownloadSizeBy:1];
		[self request:nil incrementUploadSizeBy:1];
	}
	// Tell the request not to increment the upload size when it starts, as we've already added its length
	if ([request shouldResetUploadProgress]) {
		[self resetProgressDelegate:&uploadProgressDelegate];
		[request setShouldResetUploadProgress:NO];
	}
	
	[request setShowAccurateProgress:[self showAccurateProgress]];
	
	[request setQueue:self];
	[super addOperation:request];

}

- (void)requestStarted:(EMASIHTTPRequest *)request
{
	if ([self requestDidStartSelector]) {
		[[self delegate] performSelector:[self requestDidStartSelector] withObject:request];
	}
}

- (void)request:(EMASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
	if ([self requestDidReceiveResponseHeadersSelector]) {
		[[self delegate] performSelector:[self requestDidReceiveResponseHeadersSelector] withObject:request withObject:responseHeaders];
	}
}

- (void)request:(EMASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
	if ([self requestWillRedirectSelector]) {
		[[self delegate] performSelector:[self requestWillRedirectSelector] withObject:request withObject:newURL];
	}
}

- (void)requestFinished:(EMASIHTTPRequest *)request
{
	[self setRequestsCount:[self requestsCount]-1];
	if ([self requestDidFinishSelector]) {
		[[self delegate] performSelector:[self requestDidFinishSelector] withObject:request];
	}
	if ([self requestsCount] == 0) {
		if ([self queueDidFinishSelector]) {
			[[self delegate] performSelector:[self queueDidFinishSelector] withObject:self];
		}
	}
}

- (void)requestFailed:(EMASIHTTPRequest *)request
{
	[self setRequestsCount:[self requestsCount]-1];
	if ([self requestDidFailSelector]) {
		[[self delegate] performSelector:[self requestDidFailSelector] withObject:request];
	}
	if ([self requestsCount] == 0) {
		if ([self queueDidFinishSelector]) {
			[[self delegate] performSelector:[self queueDidFinishSelector] withObject:self];
		}
	}
	if ([self shouldCancelAllRequestsOnFailure] && [self requestsCount] > 0) {
		[self cancelAllOperations];
	}
	
}

- (void)request:(EMASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
	[self setBytesDownloadedSoFar:[self bytesDownloadedSoFar]+bytes];
	if ([self downloadProgressDelegate]) {
		[EMASIHTTPRequest updateProgressIndicator:&downloadProgressDelegate withProgress:[self bytesDownloadedSoFar] ofTotal:[self totalBytesToDownload]];
	}
    if (self.downloadProgressBlock) {
        _downloadProgressBlock([self bytesDownloadedSoFar], [self totalBytesToDownload]);
    }
}

- (void)request:(EMASIHTTPRequest *)request didSendBytes:(long long)bytes
{
	[self setBytesUploadedSoFar:[self bytesUploadedSoFar]+bytes];
	if ([self uploadProgressDelegate]) {
		[EMASIHTTPRequest updateProgressIndicator:&uploadProgressDelegate withProgress:[self bytesUploadedSoFar] ofTotal:[self totalBytesToUpload]];
	}
}

- (void)request:(EMASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
	[self setTotalBytesToDownload:[self totalBytesToDownload]+newLength];
}

- (void)request:(EMASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
	[self setTotalBytesToUpload:[self totalBytesToUpload]+newLength];
}


// Since this queue takes over as the delegate for all requests it contains, it should forward authorisation requests to its own delegate
- (void)authenticationNeededForRequest:(EMASIHTTPRequest *)request
{
	if ([[self delegate] respondsToSelector:@selector(authenticationNeededForRequest:)]) {
		[[self delegate] performSelector:@selector(authenticationNeededForRequest:) withObject:request];
	}
}

- (void)proxyAuthenticationNeededForRequest:(EMASIHTTPRequest *)request
{
	if ([[self delegate] respondsToSelector:@selector(proxyAuthenticationNeededForRequest:)]) {
		[[self delegate] performSelector:@selector(proxyAuthenticationNeededForRequest:) withObject:request];
	}
}


- (BOOL)respondsToSelector:(SEL)selector
{
	// We handle certain methods differently because whether our delegate implements them or not can affect how the request should behave

	// If the delegate implements this, the request will stop to wait for credentials
	if (selector == @selector(authenticationNeededForRequest:)) {
		if ([[self delegate] respondsToSelector:@selector(authenticationNeededForRequest:)]) {
			return YES;
		}
		return NO;

	// If the delegate implements this, the request will to wait for credentials
	} else if (selector == @selector(proxyAuthenticationNeededForRequest:)) {
		if ([[self delegate] respondsToSelector:@selector(proxyAuthenticationNeededForRequest:)]) {
			return YES;
		}
		return NO;

	// If the delegate implements requestWillRedirectSelector, the request will stop to allow the delegate to change the url
	} else if (selector == @selector(request:willRedirectToURL:)) {
		if ([self requestWillRedirectSelector] && [[self delegate] respondsToSelector:[self requestWillRedirectSelector]]) {
			return YES;
		}
		return NO;
	}
	return [super respondsToSelector:selector];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	EMASINetworkQueue *newQueue = [[[self class] alloc] init];
	[newQueue setDelegate:[self delegate]];
	[newQueue setRequestDidStartSelector:[self requestDidStartSelector]];
	[newQueue setRequestWillRedirectSelector:[self requestWillRedirectSelector]];
	[newQueue setRequestDidReceiveResponseHeadersSelector:[self requestDidReceiveResponseHeadersSelector]];
	[newQueue setRequestDidFinishSelector:[self requestDidFinishSelector]];
	[newQueue setRequestDidFailSelector:[self requestDidFailSelector]];
	[newQueue setQueueDidFinishSelector:[self queueDidFinishSelector]];
	[newQueue setUploadProgressDelegate:[self uploadProgressDelegate]];
	[newQueue setDownloadProgressDelegate:[self downloadProgressDelegate]];
	[newQueue setShouldCancelAllRequestsOnFailure:[self shouldCancelAllRequestsOnFailure]];
	[newQueue setShowAccurateProgress:[self showAccurateProgress]];
	[newQueue setUserInfo:[[[self userInfo] copyWithZone:zone] autorelease]];
	return newQueue;
}


@synthesize requestsCount;
@synthesize bytesUploadedSoFar;
@synthesize totalBytesToUpload;
@synthesize bytesDownloadedSoFar;
@synthesize totalBytesToDownload;
@synthesize shouldCancelAllRequestsOnFailure;
@synthesize uploadProgressDelegate;
@synthesize downloadProgressDelegate;
@synthesize requestDidStartSelector;
@synthesize requestDidReceiveResponseHeadersSelector;
@synthesize requestWillRedirectSelector;
@synthesize requestDidFinishSelector;
@synthesize requestDidFailSelector;
@synthesize queueDidFinishSelector;
@synthesize delegate;
@synthesize showAccurateProgress;
@synthesize userInfo;
@end
