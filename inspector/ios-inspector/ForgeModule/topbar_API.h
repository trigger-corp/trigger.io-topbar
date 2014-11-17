//
//  topbar_API.h
//  Forge
//
//  Created by Connor Dunn on 15/03/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topbar_API : NSObject

+ (void)show:(ForgeTask*)task;
+ (void)hide:(ForgeTask*)task;
+ (void)setTitle:(ForgeTask*)task title:(NSString*)title;
+ (void)setTitleImage:(ForgeTask*)task icon:(NSString*)icon;
+ (void)setTint:(ForgeTask *)task color:(NSArray*)color;
+ (void)setTitleTint:(ForgeTask *)task color:(NSArray*)color;
+ (void)addButton:(ForgeTask*)task;
+ (void)removeButtons:(ForgeTask*)task;

@end
