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
#import "GameParameters.h"


FIX_CATEGORY_BUG(NSDictionary_Card);

@implementation NSDictionary (Card)

-(NSString*) tweetText
{
    return [self objectForKey:@"text"];
}

-(NSString*) cardText
{
    NSDictionary* gameData = [self gameId];
    NSString* cardId = [gameData objectForKey:@"CARDID"];
    int cardInd = [cardId intValue];
    NSString* cardText = [[GameParameters sharedParameters] getBlackCardForId:cardInd];
    return cardText;

}

-(NSDictionary*) gameId
{
    NSString* message = [self objectForKey:@"text"];
    
    NSString* gameCode = [message substringWithRange:NSMakeRange(6, 7)];
    NSString* playType = [gameCode substringWithRange:NSMakeRange(0,1)];
    NSString* gameId = [gameCode substringWithRange:NSMakeRange(1,3)];
    NSString* cardId = [gameCode substringWithRange:NSMakeRange(4,3)];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          gameCode,@"GAMECODE",
                          playType,@"PLAYTYPE",
                          gameId,@"GAMEID",
                          cardId,@"CARDID", nil];
    
    return dict;
}

-(NSURL*) senderImage
{
    return [NSURL URLWithString:[[self objectForKey:@"user"] objectForKey:@"profile_image_url"]];
}

-(NSString*) senderUsername
{
    return [[self objectForKey:@"user"] objectForKey:@"screen_name"];
}



@end


@implementation TwitterCache

@synthesize blackCards, whiteCards, doneCards;

static TwitterCache* _cache;

+ (TwitterCache*) sharedCache {
    if (_cache == nil) {
        _cache = [[TwitterCache alloc] init];
    }
    return _cache;
}

- (NSDictionary*) dataForCreateGame:(NSString*)blackCardText
{
    int gameInd = rand() % 1000;
    int cardInd = [[GameParameters sharedParameters] getBlackCardInd:blackCardText];
    
    NSString* gameId = [NSString stringWithFormat:@"%03d",gameInd];
    NSString* cardId = [NSString stringWithFormat:@"%03d",cardInd];
    NSString* response = blackCardText;
    if ([blackCardText length] > 120)
     response = [blackCardText substringToIndex:120];
    
    NSString* string = [NSString stringWithFormat:@"#TAH #0%@%@ %@",gameId,cardId,response];
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                          string,@"TWEET",
                          gameId,@"GAMEID",
                          cardId,@"CARDID"
                          , nil];
    return data;
}

- (NSString*) tweetForWhiteCard:(WhiteCard*)whiteCard onBlackCard:(BlackCard*)blackCard
{
    NSDictionary* gameData = [blackCard gameId];
    
    NSString* gameId = [gameData objectForKey:@"GAMEID"];
    
    int whiteCardInd = [[GameParameters sharedParameters] getWhiteCardInd:whiteCard];
    
    NSString* response = GETTEXT(@"SEND_WHITE_CARD");
    // need to define and cache black player
    NSString* black_player = [blackCard senderUsername];
    NSString* string = [NSString stringWithFormat:@"#TAH #1%@%03d \@%@ %@", gameId,whiteCardInd,black_player,response];
    
    return string;
}

- (BOOL) isLoggedIn {
    return [TWTweetComposeViewController canSendTweet];
}


- (NSArray*) getFriends {
    
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
                    //Get the Latest Trends
                    TWRequest *getTrends = [[TWRequest alloc] initWithURL:
                    [NSURL URLWithString:@"http://api.twitter.com/1/trends.json"] 
                        parameters:nil requestMethod:TWRequestMethodGET];
                              [getTrends setAccount:acct];
                              NSLog(@"TRENDS BITCHES%@", [getTrends description]);
                              
                              
                              // This will add black card messages upon refresh
                              if (results) {
                                  NSMutableArray* newCards = [[NSMutableArray alloc] init];
                                  for (NSDictionary* tweet in results) {
                                      NSString* message = [tweet objectForKey:@"text"];
                                      if ([message hasPrefix:@"#TAH #"] || [message hasPrefix:@"#tah #"]) {
                                          //NSDictionary* gameData = [tweet gameId];
                                          [newCards addObject:tweet];
                                      }
                                  }
                                  blackCards = newCards;
                              }
                              else { 
                                  // Inspect the contents of jsonError
                                  NSLog(@"%@", jsonError);
                              }
                          }
                          
                          
                          [[NSNotificationCenter defaultCenter] postNotificationName:eTweetsUpdated object:self];
                          
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
