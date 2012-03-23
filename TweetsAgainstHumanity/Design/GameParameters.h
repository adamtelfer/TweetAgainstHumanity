//
//  GameParameters.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GETTEXT(key) [[GameParameters sharedParameters] getTextForKey:key]

@interface GameParameters : NSObject
{
    NSArray* responses;
    NSArray* categories;
}

+ (GameParameters*) sharedParameters;

@property (strong) NSDictionary* gameText;

- (NSString*) getBlackCardForId:(int)ind;

- (NSString*) getRandomWhiteCard:(int)seed;
- (NSString*) getRandomBlackCard:(int)seed;

- (NSString*) getTextForKey:(NSString*)key;

@end
