//
//  TwitterCache.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#define eTweetsUpdated @"eTweetsUpdated"

typedef NSDictionary BlackCard;
typedef NSString WhiteCard;

@interface NSDictionary (Card)

- (NSDictionary*) gameId;

-(NSString*) tweetText;
-(NSString*) cardText;
-(NSURL*) senderImage;
-(NSString*) senderUsername;

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

- (NSString*) tweetForCreateGame:(NSString*)blackCardText;

- (NSString*) tweetForWhiteCard:(WhiteCard*)whiteCard onBlackCard:(BlackCard*)blackCard;

- (BOOL) isLoggedIn;

@end
