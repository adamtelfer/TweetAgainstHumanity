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

- (void) refresh 
{
    
    NSURL* requestURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=brandonmat&count=5&include_entities=1&include_rts=1"];
    
    TWRequest* request = [[TWRequest alloc] initWithURL:requestURL parameters:nil requestMethod:TWRequestMethodGET];
    
    //  Perform our request
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         
         if (responseData) {
             //  Use the NSJSONSerialization class to parse the returned JSON
             NSError *jsonError;
             NSArray *timeline = 
             [NSJSONSerialization JSONObjectWithData:responseData 
                                             options:NSJSONReadingMutableLeaves 
                                               error:&jsonError];
             
             if (timeline) {
                 // We have an object that we can parse
                 NSLog(@"%@", timeline);
             } 
             else { 
                 // Inspect the contents of jsonError
                 NSLog(@"%@", jsonError);
             }
         }
     }];
    
}

- (id) init {
    self = [super init];
    
    if (self) {
        [self refresh];
    }
    
    return self;
    
}


@end
