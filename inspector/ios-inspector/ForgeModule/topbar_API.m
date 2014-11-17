//
//  topbar_API.m
//  Forge
//
//  Created by Connor Dunn on 15/03/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "topbar_API.h"
#import "topbar_Delegate.h"
#import "topbar_Util.h"


extern UINavigationBar *topbar;
extern UIStatusBarStyle topbar_statusBarStyle;
@implementation topbar_API

static bool hidden = NO;

+ (void)show:(ForgeTask*)task {
	if (hidden) {
		// Resize webview
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			[[ForgeApp sharedApp] webView].frame = CGRectMake([[ForgeApp sharedApp] webView].frame.origin.x, [[ForgeApp sharedApp] webView].frame.origin.y + topbar.frame.size.height, [[ForgeApp sharedApp] webView].frame.size.width, [[ForgeApp sharedApp] webView].frame.size.height - topbar.frame.size.height);
            
		} else if (NSClassFromString(@"WKWebView") && [[ForgeApp sharedApp] useWKWebView]) {
            WKWebView *webView = (WKWebView*)[[ForgeApp sharedApp] webView];
            UIEdgeInsets inset = webView.scrollView.contentInset;
            UIEdgeInsets newInset = UIEdgeInsetsMake(inset.top + [topbar_Util topbarInset:topbar], inset.left, inset.bottom, inset.right);
            [webView.scrollView setContentInset:newInset];
            [webView.scrollView setScrollIndicatorInsets:newInset];
            
        } else {
            UIWebView *webView = (UIWebView*)[[ForgeApp sharedApp] webView];
            UIEdgeInsets inset = webView.scrollView.contentInset;
            UIEdgeInsets newInset = UIEdgeInsetsMake(inset.top + [topbar_Util topbarInset:topbar], inset.left, inset.bottom, inset.right);
            [webView.scrollView setContentInset:newInset];
            [webView.scrollView setScrollIndicatorInsets:newInset];
        }
		
		[topbar setHidden:NO];
		
		[[ForgeApp sharedApp] hideStatusBarBox];
		hidden = NO;
	}
	[task success:nil];
}

+ (void)hide:(ForgeTask*)task {
	if (!hidden) {
        // Resize webview
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            [[ForgeApp sharedApp] webView].frame = CGRectMake([[ForgeApp sharedApp] webView].frame.origin.x, [[ForgeApp sharedApp] webView].frame.origin.y - topbar.frame.size.height, [[ForgeApp sharedApp] webView].frame.size.width, [[ForgeApp sharedApp] webView].frame.size.height + topbar.frame.size.height);
            
        } else if (NSClassFromString(@"WKWebView") && [[ForgeApp sharedApp] useWKWebView]) {
            WKWebView *webView = (WKWebView*)[[ForgeApp sharedApp] webView];
            UIEdgeInsets inset = webView.scrollView.contentInset;
            UIEdgeInsets newInset = UIEdgeInsetsMake(inset.top - [topbar_Util topbarInset:topbar], inset.left, inset.bottom, inset.right);
            [webView.scrollView setContentInset:newInset];
            [webView.scrollView setScrollIndicatorInsets:newInset];
            
        } else {
            UIWebView *webView = (UIWebView*)[[ForgeApp sharedApp] webView];
            UIEdgeInsets inset = webView.scrollView.contentInset;
            UIEdgeInsets newInset = UIEdgeInsetsMake(inset.top - [topbar_Util topbarInset:topbar], inset.left, inset.bottom, inset.right);
            [webView.scrollView setContentInset:newInset];
            [webView.scrollView setScrollIndicatorInsets:newInset];
        }
        
		[topbar setHidden:YES];
		
		[[ForgeApp sharedApp] showStatusBarBox];
		hidden = YES;
	}
	[task success:nil];
}

+ (void)setTitle:(ForgeTask*)task title:(NSString*)title {
	if (![title isKindOfClass:[NSString class]]) {
		[task error:@"Invalid input" type:@"BAD_INPUT" subtype:nil];
		return;
	}
	UINavigationItem *navItem = ((UINavigationItem*)[topbar.items objectAtIndex:0]);
	navItem.titleView = nil;
	navItem.title = title;
	[task success:nil];
}

+ (void)setTitleImage:(ForgeTask*)task icon:(NSObject*)icon {
	UINavigationItem *navItem = ((UINavigationItem*)[topbar.items objectAtIndex:0]);

	[[[ForgeFile alloc] initWithObject:icon] data:^(NSData *data) {
		UIImage *titleImage = [[UIImage alloc] initWithData:data];
		
		if (titleImage == nil) {
			[task error:@"Invalid input" type:@"BAD_INPUT" subtype:nil];
			return;
		}
		
		UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
		// Scale down the image if too big
		if ([titleImageView frame].size.height > [topbar frame].size.height) {
			[titleImageView setFrame:CGRectInset([titleImageView frame], 0, floor(([titleImageView frame].size.height-[topbar frame].size.height)/2))];
		}
		[titleImageView setContentMode:UIViewContentModeScaleAspectFit];
		navItem.titleView = titleImageView;
		[task success:nil];
		
	} errorBlock:^(NSError *error) {
		[task error:@"Failed to load image" type:@"UNEXPECTED_FAILURE" subtype:nil];
	}];
}

+ (void)setTint:(ForgeTask *)task color:(NSArray*)color {
	UIColor *uiColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255 green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255 blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255 alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]/255];
	
	if ([ForgeApp sharedApp].statusBarBox) {
		[[ForgeApp sharedApp].statusBarBox setBarTintColor:uiColor];
	}

	[topbar setBarStyle:UIBarStyleDefault];
	if ([topbar respondsToSelector:@selector(setBarTintColor:)]) {
		[topbar setBarTintColor:uiColor];
	} else {
		[topbar setTintColor:uiColor];
	}
	[task success:nil];
}

+ (void)setTitleTint:(ForgeTask *)task color:(NSArray*)color {
    UIColor *uiColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255 green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255 blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255 alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]/255];
    
    if ([topbar respondsToSelector:@selector(setTitleTextAttributes:)]) {
        [topbar setTitleTextAttributes:@{ NSForegroundColorAttributeName:uiColor }];
    }
    [task success:nil];
}

+ (void)addButton:(ForgeTask*)task {
	UINavigationItem *navItem = ((UINavigationItem*)[topbar.items objectAtIndex:0]);

	topbar_Delegate* delegate;
	if ([[task.params objectForKey:@"type"] isEqualToString:@"back"]) {
		delegate = [[topbar_Delegate alloc] initWithId:@"back"];
	} else {
		delegate = [[topbar_Delegate alloc] initWithId:task.callid];
	}
	
	UIBarButtonItem *button;
	if ([[task.params objectForKey:@"style"] isEqualToString:@"back"] && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		UIColor *tintColor;
		if ([task.params objectForKey:@"tint"] != nil) {
			NSArray* color = [task.params objectForKey:@"tint"];
			tintColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255 green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255 blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255 alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]*0.7/255];
		} else {
			tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		}
		
		// Generate the background images
		UIImage *stretchableBackButton = [[topbar_Util image:[UIImage imageNamed:@"topbar.bundle/UINavigationBarBlackOpaqueBack"] withTint:tintColor] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
		UIImage *stretchableBackButtonPressed = [[topbar_Util image:[UIImage imageNamed:@"topbar.bundle/UINavigationBarBlackOpaqueBackPressed"] withTint:tintColor] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
		
		// Setup the UIButton
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[backButton setBackgroundImage:stretchableBackButton forState:UIControlStateNormal];
		[backButton setBackgroundImage:stretchableBackButtonPressed forState:UIControlStateHighlighted];
		
		if ([task.params objectForKey:@"text"] != nil) {
			NSString *buttonTitle = [task.params objectForKey:@"text"];
			[backButton setTitle:buttonTitle forState:UIControlStateNormal];
			[backButton setTitle:buttonTitle forState:UIControlStateHighlighted];
			backButton.titleEdgeInsets = UIEdgeInsetsMake(1, 8, 2, 1); // Tweak the text position
			NSInteger width = ([backButton.titleLabel.text sizeWithFont:backButton.titleLabel.font].width + backButton.titleEdgeInsets.right +backButton.titleEdgeInsets.left);
			[backButton setFrame:CGRectMake(0, 0, width, 29)];
			backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		} else {
			[[[ForgeFile alloc] initWithObject:[task.params objectForKey:@"icon"]] data:^(NSData *data) {
				UIImage *icon = [[UIImage alloc] initWithData:data];
				icon = [icon imageWithWidth:0 andHeight:28 andRetina:YES];
				
				UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
				iconView.frame = CGRectMake(17, 0, icon.size.width, icon.size.height);
				[backButton setFrame:CGRectMake(0, 0, icon.size.width+27, 29)];
				
				[backButton addSubview:iconView];
			} errorBlock:^(NSError *error) {
			}];
		}

		[backButton addTarget:delegate action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
		button = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	} else if ([[task.params objectForKey:@"style"] isEqualToString:@"back"] && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		UIColor *tintColor;
		if ([task.params objectForKey:@"tint"] != nil) {
			NSArray* color = [task.params objectForKey:@"tint"];
			tintColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255 green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255 blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255 alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]*0.7/255];
		} else {
			tintColor = [UIColor colorWithRed:0 green:122.0f/255.0f blue:1 alpha:1];
		}
		
		// Generate the background images
		UIImage *stretchableBackButton = [[topbar_Util image:[UIImage imageNamed:@"topbar.bundle/UINavigationBarBackIndicatorDefault"] withTint:tintColor] stretchableImageWithLeftCapWidth:13.5 topCapHeight:0];
				
		// Setup the UIButton
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
		backButton.tintColor = tintColor;
		[backButton setBackgroundImage:stretchableBackButton forState:UIControlStateNormal];
		
		if ([task.params objectForKey:@"text"] != nil) {
			NSString *buttonTitle = [task.params objectForKey:@"text"];
			[backButton setTitle:buttonTitle forState:UIControlStateNormal];
			backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0); // Tweak the text position
			NSInteger width = ([backButton.titleLabel.text sizeWithFont:backButton.titleLabel.font].width + backButton.titleEdgeInsets.right +backButton.titleEdgeInsets.left);
			[backButton setFrame:CGRectMake(0, 0, width, 20.5)];

		} else {
			[[[ForgeFile alloc] initWithObject:[task.params objectForKey:@"icon"]] data:^(NSData *data) {
				UIImage *icon = [[UIImage alloc] initWithData:data];
				icon = [icon imageWithWidth:0 andHeight:28 andRetina:YES];
				
				UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
				iconView.frame = CGRectMake(17, 0, icon.size.width, icon.size.height);
				[backButton setFrame:CGRectMake(0, 0, icon.size.width+27, 29)];
				
				[backButton addSubview:iconView];
			} errorBlock:^(NSError *error) {
			}];
		}

		[backButton addTarget:delegate action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
		button = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	} else {
		if ([task.params objectForKey:@"text"] != nil) {
			button = [[UIBarButtonItem alloc] initWithTitle:[task.params objectForKey:@"text"] style:UIBarButtonItemStylePlain target:delegate action:@selector(clicked)];
		} else {
			// TODO: Not sure this is a good idea
			dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
			
			__block UIImage *icon = nil;
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
				[[[ForgeFile alloc] initWithObject:[task.params objectForKey:@"icon"]] data:^(NSData *data) {
					icon = [[UIImage alloc] initWithData:data];
					icon = [icon imageWithWidth:0 andHeight:28 andRetina:YES];
					
					dispatch_semaphore_signal(semaphore);
				} errorBlock:^(NSError *error) {
					dispatch_semaphore_signal(semaphore);
				}];
			});

			// Wait for async
			dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
			
			if ([task.params objectForKey:@"prerendered"]) {
				UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
				
				UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(clicked)];
				[tap setNumberOfTapsRequired:1];
				[imageView setUserInteractionEnabled:YES];
				[imageView addGestureRecognizer:tap];
			
				button = [[UIBarButtonItem alloc] initWithCustomView:imageView];
			} else {
				button = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:delegate action:@selector(clicked)];
			}
		}
		if ([[task.params objectForKey:@"style"] isEqualToString:@"done"]) {
			[button setStyle:UIBarButtonItemStyleDone];
		}
		if ([task.params objectForKey:@"tint"] != nil && ![[task.params objectForKey:@"tint"] isKindOfClass:[NSArray class]]) {
			[task error:@"Invalid tint" type:@"BAD_INPUT" subtype:nil];
			return;
		}
		if ([task.params objectForKey:@"tint"] != nil && [button respondsToSelector:@selector(setTintColor:)]) {
			NSArray* color = [task.params objectForKey:@"tint"];
			button.tintColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255 green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255 blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255 alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]/255];
		}
	}
	
	
	if (![[task.params objectForKey:@"position"] isEqualToString:@"left"] && navItem.rightBarButtonItem == nil) {
		[navItem setRightBarButtonItem:button];
		[task success:task.callid];
	} else if (navItem.leftBarButtonItem == nil) {
		[navItem setLeftBarButtonItem:button];
		[task success:task.callid];
	} else {
		[task error:@"Button already exists" type:@"EXPECTED_FAILURE" subtype:nil];
	}
}

+ (void)removeButtons:(ForgeTask*)task {
	UINavigationItem *navItem = ((UINavigationItem*)[topbar.items objectAtIndex:0]);
	
	if (navItem.leftBarButtonItem != nil) {
		[((topbar_Delegate*)navItem.leftBarButtonItem.target) releaseDelegate];
		[navItem setLeftBarButtonItem:nil];
	}

	if (navItem.rightBarButtonItem != nil) {
		[((topbar_Delegate*)navItem.rightBarButtonItem.target) releaseDelegate];
		[navItem setRightBarButtonItem:nil];
	}
	
	[task success:nil];
}

+ (void)setStatusBarStyle:(ForgeTask*)task style:(NSString*)style {
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		if ([style isEqualToString:@"light_content"]) {
			topbar_statusBarStyle = UIStatusBarStyleLightContent;
			topbar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
		} else {
			topbar_statusBarStyle = UIStatusBarStyleDefault;
			topbar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
		}
		[[ForgeApp sharedApp].viewController setNeedsStatusBarAppearanceUpdate];
		[task success:nil];
	} else {
		[task error:@"Not available on this version of iOS." type:@"UNAVAILABLE" subtype:nil];
	}
}

@end
