//
//  TwitterCache.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterCache.h"
#import <Twitter/Twitter.h>

@implementation TwitterCache

static TwitterCache* _cache;

+ (TwitterCache*) sharedCache {
    if (_cache == nil) {
        _cache = [[TwitterCache alloc] init];
    }
    return _cache;
}

- (BOOL) isLoggedIn {
    return [TWTweetComposeViewController canSendTweet];
    
}

@end
