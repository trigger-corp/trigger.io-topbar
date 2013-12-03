//
//  topbar_Delegate.h
//  Forge
//
//  Created by Connor Dunn on 15/03/2012.
//  Copyright (c) 2012 Trigger Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topbar_Delegate : NSObject {
	NSString *callId;
	topbar_Delegate *me;
}

- (topbar_Delegate*) initWithId:(NSString *)newId;
- (void) releaseDelegate;

@end
