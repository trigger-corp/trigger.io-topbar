//
//  topbar_Util.m
//  ForgeModule
//
//  Created by Connor Dunn on 21/01/2013.
//  Copyright (c) 2013 Trigger Corp. All rights reserved.
//

#import "topbar_Util.h"

@implementation topbar_Util

// Tint the image
+ (UIImage *)image:(UIImage*)image withTint:(UIColor *)tintColor {
	
    // Begin drawing
    CGRect aRect = CGRectMake(0.f, 0.f, image.size.width*image.scale, image.size.height*image.scale);
    UIGraphicsBeginImageContext(aRect.size);
	
    // Get the graphic context
    CGContextRef c = UIGraphicsGetCurrentContext();
	
    // Draw the image
    [image drawInRect:aRect];
	
    // Set the fill color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(c, colorSpace);
	
    // Set the fill color
    CGContextSetFillColorWithColor(c, tintColor.CGColor);
	
	// This isn't quite right, ColorDodge is closer but colours transparent sections
    UIRectFillUsingBlendMode(aRect, kCGBlendModeSourceAtop);
	
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    // Release memory
    CGColorSpaceRelease(colorSpace);
	
    return [img imageWithWidth:image.size.width andHeight:image.size.height andRetina:image.scale];
}

+ (int) topbarInset:(UINavigationBar*)topbar {
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		return 0;
	} else {
		NSDictionary* config = [[ForgeApp sharedApp] configForPlugin:@"display"];
		if ([[[config objectForKey:@"fullscreen"] objectForKey:@"ios7"] isEqualToString:@"webview-under-statusbar"]) {
			return topbar.frame.size.height + 20;
		} else {
			return topbar.frame.size.height;
		}
	}
}

+ (bool) iPad2Bug {
    bool is_ios9 = floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber10_9; // only manifests on iOS 9 so far
    bool is_ipad = [[[UIDevice currentDevice] model] hasPrefix:@"iPad"]; // manifests on the iPad
    bool is_iphone_app = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone; // when the app has been targeted for the iPhone
    bool is_retina = [[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)] &&
                     [[UIScreen mainScreen] nativeScale] == 2.0; // but only on non-retina iPads

    return is_ios9 && is_ipad && is_iphone_app && !is_retina;
}

@end
