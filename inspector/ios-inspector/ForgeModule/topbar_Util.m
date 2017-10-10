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


@end
