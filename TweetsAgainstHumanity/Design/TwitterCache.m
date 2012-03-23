//
//  TwitterCache.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterCache.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@implementation TwitterCache

@synthesize blackCards, whiteCards, doneCards;

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
    if ([TWTweetComposeViewController canSendTweet]) 
    {
        // Create account store, followed by a twitter account identifier
        // At this point, twitter is the only account type available
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                 // Sanity check
                 if ([arrayOfAccounts count] > 0) 
                 {
                     // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                     
                     // Build a twitter request
                     TWRequest *getRequest = [[TWRequest alloc] initWithURL:
                                               [NSURL URLWithString:@"https://api.twitter.com/1/statuses/mentions.json?include_entities=true"] 
                                                                  parameters:nil requestMethod:TWRequestMethodGET];
                     
                     // Post the request
                     [getRequest setAccount:acct];
                     NSLog(@"Twitter Request %@", [getRequest description]);
                     
                     
                     // Block handler to manage the response
                     [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                      {
                          NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);

                          
                          // Testing - Json to take responeData and return string
                          if (responseData) {
                              //  Use the NSJSONSerialization class to parse the returned JSON
                              NSError *jsonError;
                              NSArray *results = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                                       options:NSJSONReadingMutableLeaves 
                                                                                         error:&jsonError];
                              
                              // This will add black card messages upon refresh
                              if (results) {
                                  for (NSDictionary* tweet in results) {
                                      NSString* message = [tweet objectForKey:@"text"];
                                      NSRegularExpression *gamecodes = [[NSRegularExpression alloc] initWithPattern:@"" options:NSRegularExpressionCaseInsensitive error:nil];
                                                                   
                                      if ([message rangeOfString:@"#tah"].location != NSNotFound) {
                                          blackCards = message;
                                          NSLog(@"Message added %@", [message description]);
                                      }
                                  }
                                  blackCards = results;
                              }
                              else { 
                                  // Inspect the contents of jsonError
                                  NSLog(@"%@", jsonError);
                              }
                          }
                          
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:eTweetsUpdated object:nil];
                          
                      }];
                 }
             }
         }];
    }
}

- (id) init {
    self = [super init];
    
    if (self) {
        [self refresh];
    }
    
    return self;
    
}


@end
