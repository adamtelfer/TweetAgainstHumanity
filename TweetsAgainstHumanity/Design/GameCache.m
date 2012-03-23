//
//  GameCache.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCache.h"

@implementation GameCache

@synthesize savedGames;

static GameCache* _cache;

+ (GameCache*) sharedCache
{
    if (_cache == nil) _cache = [[GameCache alloc] init];
    return _cache;
}

- (id) init {
    self = [super init];
    if (self) {
        savedGames = [[NSMutableArray alloc] init];
        NSString *fullPath = [NSBundle pathForResource:@"savedgames" ofType:@"plist" inDirectory:[NSHomeDirectory() stringByAppendingString:@"/Documents/"]];
        NSArray* oldGames = [NSArray arrayWithContentsOfFile:fullPath];
        [savedGames addObjectsFromArray:oldGames];
        
    }
    return self;
    
}

- (void) addSavedGame:(NSDictionary*)blackCard
{
    [savedGames addObject:blackCard];
    NSString *fullPath = [NSBundle pathForResource:@"savedgames" ofType:@"plist" inDirectory:[NSHomeDirectory() stringByAppendingString:@"/Documents/"]];
    [savedGames writeToFile:fullPath atomically:YES];
}



@end
