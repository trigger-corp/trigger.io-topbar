//
//  topbar_EventListener.m
//  Forge
//
//  Created by Connor Dunn on 15/03/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import "topbar_EventListener.h"
#import "topbar_Delegate.h"
#import "topbar_Util.h"

UIStatusBarStyle topbar_statusBarStyle = UIStatusBarStyleDefault;
UINavigationBar *topbar;

@interface topbar_BarDelegate : NSObject <UIBarPositioningDelegate> {
	topbar_BarDelegate *me;
}
@end

@implementation topbar_BarDelegate

- (id)init
{
    self = [super init];
    if (self) {
        me = self;
    }
    return self;
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
	return UIBarPositionTopAttached;
}

@end

@implementation topbar_EventListener

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Create the topbar
	topbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, [ForgeApp sharedApp].webviewTop, 320.0f, 44.0f)];
	topbar.autoresizingMask = UIViewAutoresizingNone | UIViewAutoresizingFlexibleWidth;
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		[topbar setBarStyle:UIBarStyleBlack];
	}
	
	topbar_BarDelegate *delegate = [[topbar_BarDelegate alloc] init];
	topbar.delegate = delegate;
	
	// Add the title
	UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
	[topbar pushNavigationItem:title animated:NO];

	// Resize webview scroll area
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		[[ForgeApp sharedApp] webView].frame = CGRectMake([[ForgeApp sharedApp] webView].frame.origin.x, [[ForgeApp sharedApp] webView].frame.origin.y + topbar.frame.size.height, [[ForgeApp sharedApp] webView].frame.size.width, [[ForgeApp sharedApp] webView].frame.size.height - topbar.frame.size.height);
	} else {
		UIEdgeInsets inset = [[ForgeApp sharedApp] webView].scrollView.contentInset;
		UIEdgeInsets newInset = UIEdgeInsetsMake(inset.top + [topbar_Util topbarInset:topbar], inset.left, inset.bottom, inset.right);
		[[[ForgeApp sharedApp] webView].scrollView setContentInset:newInset];
		[[[ForgeApp sharedApp] webView].scrollView setScrollIndicatorInsets:newInset];
	}

	// Add topbar to view
	[[[ForgeApp sharedApp] viewController].view insertSubview:topbar aboveSubview:[ForgeApp sharedApp].webView];
	[[ForgeApp sharedApp] hideStatusBarBox];
}

+ (void) preFirstWebViewLoad {
	// Reset topbar on first load/reload
	UINavigationItem *navItem = ((UINavigationItem*)[topbar.items objectAtIndex:0]);
	
	if (navItem.leftBarButtonItem != nil) {
		[((topbar_Delegate*)navItem.leftBarButtonItem.target) releaseDelegate];
		[navItem setLeftBarButtonItem:nil];
	}
	
	if (navItem.rightBarButtonItem != nil) {
		[((topbar_Delegate*)navItem.rightBarButtonItem.target) releaseDelegate];
		[navItem setRightBarButtonItem:nil];
	}

	navItem.titleView = nil;
	navItem.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSNumber *)preferredStatusBarStyle {
	return [NSNumber numberWithInt:topbar_statusBarStyle];
}

@end
