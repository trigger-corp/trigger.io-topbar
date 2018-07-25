//
//  topbar_EventListener.m
//  Forge
//
//  Created by Connor Dunn on 15/03/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "topbar_EventListener.h"
#import "topbar_Delegate.h"
#import "topbar_Util.h"

UIStatusBarStyle topbar_statusBarStyle = UIStatusBarStyleDefault;

@interface topbar_BarDelegate : UIViewController <UIBarPositioningDelegate, UINavigationBarDelegate> {
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

@end


@implementation topbar_EventListener

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *style = [[[ForgeApp sharedApp] configForModule:@"topbar"] objectForKey:@"statusBarStyle"];
    if (style) {
        [ForgeLog d:@"topbar.statusBarStyle is deprecated. See display module config."];
    }
    
    // Show topbar by default
    ForgeApp.sharedApp.viewController.navigationBarHidden = NO;
}


+ (void) preFirstWebViewLoad {
    // Reset topbar on first load/reload
    UINavigationBar *navigationBar = ForgeApp.sharedApp.viewController.navigationBar;
    UINavigationItem *navItem = ((UINavigationItem*)[navigationBar.items objectAtIndex:0]);

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


@end
