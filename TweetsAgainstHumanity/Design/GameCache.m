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

- (NSString*) generateGameId
{
    return @"000";
}

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
        
        NSLog(@"Saved Games : %@", [savedGames description]);
        NSLog(@"");
    }
    return self;
}

- (void) addSavedGame:(NSDictionary*)blackCard
{
    [savedGames addObject:blackCard];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"savedgames.plist"]; //3
    [savedGames writeToFile:path atomically:YES];
}



@end
