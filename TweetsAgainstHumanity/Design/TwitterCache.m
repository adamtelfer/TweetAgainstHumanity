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
    
    NSURL* requestURL = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=%23TAH_BLK"];
    TWRequest* request = [[TWRequest alloc] initWithURL:requestURL parameters:nil requestMethod:TWRequestMethodGET];
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         
         if (responseData) {
             //  Use the NSJSONSerialization class to parse the returned JSON
             NSError *jsonError;
             NSDictionary *timeline = [NSJSONSerialization JSONObjectWithData:responseData 
                                             options:NSJSONReadingMutableLeaves 
                                               error:&jsonError];
             NSArray* results = [timeline objectForKey:@"results"];
             if (results) {
                 blackCards = results;
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
