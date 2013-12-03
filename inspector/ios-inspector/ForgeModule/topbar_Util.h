//
//  topbar_Util.h
//  ForgeModule
//
//  Created by Connor Dunn on 21/01/2013.
//  Copyright (c) 2013 Trigger Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topbar_Util : NSObject

+ (UIImage *)image:(UIImage*)image withTint:(UIColor *)tintColor;
+ (int) topbarInset:(UINavigationBar*)topbar;

@end
