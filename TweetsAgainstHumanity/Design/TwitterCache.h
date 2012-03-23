//
//  TwitterCache.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define eTweetsUpdated @"eTweetsUpdated"

@interface BlackCard : NSDictionary {
    
}

@property (readonly) NSString* tweetText;
@property (readonly) NSString* cardText;
@property (readonly) NSURL* senderImage;
@property (readonly) NSString* senderUsername;

@end

@interface TwitterCache : NSObject
{
    NSArray* blackCards;
    NSArray* whiteCards;
    NSArray* doneCards;
}

@property (readonly) NSArray* blackCards;
@property (readonly) NSArray* whiteCards;
@property (readonly) NSArray* doneCards;

+ (TwitterCache*) sharedCache;

- (void) refresh;

- (BOOL) isLoggedIn;

@end
