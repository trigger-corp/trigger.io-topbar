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


extern UIStatusBarStyle topbar_statusBarStyle;
@implementation topbar_API

+ (void)show:(ForgeTask*)task {
    ForgeApp.sharedApp.viewController.navigationBarHidden = NO;
    [task success:nil];
}


+ (void)hide:(ForgeTask*)task {
    ForgeApp.sharedApp.viewController.navigationBarHidden = YES;
    [task success:nil];
}


+ (void)setTitle:(ForgeTask*)task title:(NSString*)title {
    if (![title isKindOfClass:[NSString class]]) {
        [task error:@"Invalid input" type:@"BAD_INPUT" subtype:nil];
        return;
    }
    UINavigationItem *navItem = ((UINavigationItem*)[ForgeApp.sharedApp.viewController.navigationBar.items objectAtIndex:0]);
    navItem.titleView = nil;
    navItem.title = title;
    [task success:nil];
}


+ (void)setTitleImage:(ForgeTask*)task icon:(NSString*)icon {
    if (icon == nil) {
        [task error:@"Failed to load image" type:@"UNEXPECTED_FAILURE" subtype:nil];
        return;
    }

    UINavigationBar *navigationBar = ForgeApp.sharedApp.viewController.navigationBar;
    UINavigationItem *navItem = ((UINavigationItem*)[navigationBar.items objectAtIndex:0]);

    ForgeFile *forgeFile = [ForgeFile withEndpointId:ForgeStorage.EndpointIds.Source resource:icon];
    [forgeFile contents:^(NSData *data) {
        UIImage *titleImage = [[UIImage alloc] initWithData:data];
        if (titleImage == nil) {
            [task error:@"Invalid input" type:@"BAD_INPUT" subtype:nil];
            return;
        }

        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];

        // Scale down the image if too high
        if ([titleImageView frame].size.height > navigationBar.frame.size.height) {
            float inset = floor(([titleImageView frame].size.height - navigationBar.frame.size.height) / 2); // 18
            [titleImageView setFrame:CGRectInset([titleImageView frame], 0, inset)];
        }

        // Scale down the image if too wide
        if ([titleImageView frame].size.width > 200.0) {
            titleImageView.frame = CGRectMake(0.0,
                                              0.0,
                                              [titleImageView frame].size.width - 160.0,
                                              [titleImageView frame].size.height - 4.0);
        }

        // Scale to fit while maintaining aspect ratio
        [titleImageView setContentMode:UIViewContentModeScaleAspectFit];

        // Host image in a UIView subview so it stays centered
        UIView *headerView = [[UIView alloc] init];
        [headerView setFrame:[titleImageView frame]];
        [headerView addSubview:titleImageView];
        navItem.titleView = headerView;

        [task success:nil];

    } errorBlock:^(NSError *error) {
        [task error:@"Failed to load image" type:@"UNEXPECTED_FAILURE" subtype:nil];
    }];
}


+ (void)setTranslucent:(ForgeTask *)task translucent:(NSNumber*)translucent {
    [ForgeLog w:@"topbar.setTranslucent has been deprecated. Use topbar.setTint() instead."];
    [task success:nil];
}


+ (void)setTint:(ForgeTask *)task color:(NSArray*)color {
    UIView *blurView = ForgeApp.sharedApp.viewController.blurView;
    UIColor *uiColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255.0f green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255.0f blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255.0f alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]/255.0f];

    blurView.backgroundColor = uiColor;
    [task success:nil];
}


+ (void)setTitleTint:(ForgeTask *)task color:(NSArray*)color {
    UINavigationBar *navigationBar = ForgeApp.sharedApp.viewController.navigationBar;
    UIColor *uiColor = [UIColor colorWithRed:[(NSNumber*)[color objectAtIndex:0] floatValue]/255 green:[(NSNumber*)[color objectAtIndex:1] floatValue]/255 blue:[(NSNumber*)[color objectAtIndex:2] floatValue]/255 alpha:[(NSNumber*)[color objectAtIndex:3] floatValue]/255];
    
    if ([navigationBar respondsToSelector:@selector(setTitleTextAttributes:)]) {
        [navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:uiColor }];
    }
    [task success:nil];
}


+ (void)addButton:(ForgeTask*)task {
    UINavigationBar *navigationBar = ForgeApp.sharedApp.viewController.navigationBar;
    UINavigationItem *navItem = ((UINavigationItem*)[navigationBar.items objectAtIndex:0]);

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
            // This may be deprecated but it gives the right size, which is more than I can say for its replacement
            CGSize backButtonTitleSize = [backButton.titleLabel.text sizeWithFont:backButton.titleLabel.font];
            /*CGSize backButtonTitleSize = [backButton.titleLabel.text sizeWithAttributes:@{
                NSFontAttributeName: backButton.titleLabel.font
            }];*/
            NSInteger width = (backButtonTitleSize.width + backButton.titleEdgeInsets.right + backButton.titleEdgeInsets.left);
            [backButton setFrame:CGRectMake(0, 0, width, 29)];
            backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        } else {
            NSString *icon = task.params[@"icon"];
            ForgeFile *forgeFile = [ForgeFile withEndpointId:ForgeStorage.EndpointIds.Source resource:icon];
            [forgeFile contents:^(NSData *data) {
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
            // This may be deprecated but it gives the right size, which is more than I can say for its replacement
            CGSize backButtonTitleSize = [backButton.titleLabel.text sizeWithFont:backButton.titleLabel.font];
            NSInteger width = (backButtonTitleSize.width + backButton.titleEdgeInsets.right + backButton.titleEdgeInsets.left);
            [backButton setFrame:CGRectMake(0, 0, width, 20.5)];

        } else {
            NSString *resource = task.params[@"icon"];
            ForgeFile *forgeFile = [ForgeFile withEndpointId:ForgeStorage.EndpointIds.Source resource:resource];
            [forgeFile contents:^(NSData *data) {
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
                NSString *resource = task.params[@"icon"];
                ForgeFile *forgeFile = [ForgeFile withEndpointId:ForgeStorage.EndpointIds.Source resource:resource];
                [forgeFile contents:^(NSData *data) {
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

    [task success:nil];
}


@end
