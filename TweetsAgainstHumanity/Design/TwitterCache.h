//
//  TwitterCache.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define eTweetsUpdated @"eTweetsUpdated"

@interface TwitterCache : NSObject
{
    NSArray* _tweets;
}

/*
- (NSArray*) activeGames;
- (NSArray*) myGames;
- (NSArray*) finishedGames;
*/

+ (TwitterCache*) sharedCache;

- (void) refresh;

- (BOOL) isLoggedIn;

@end
