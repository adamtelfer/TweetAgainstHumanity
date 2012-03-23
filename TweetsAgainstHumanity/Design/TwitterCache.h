//
//  TwitterCache.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define eTweetsUpdated @"eTweetsUpdated"

@interface BlackCard : NSObject {
@private
    NSDictionary* tweet;
}
- (id) initWithTweetDictionary:(NSDictionary*)tweet;
@property (readonly) NSString* text;
@end

@interface TwitterCache : NSObject
{
    NSArray* blackCards;
    NSArray* whiteCards;
    NSArray* doneCards;
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
