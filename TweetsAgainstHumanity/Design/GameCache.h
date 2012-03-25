//
//  GameCache.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCache : NSObject {
    NSMutableArray* savedGames;
    
}

@property (readonly) NSMutableArray* savedGames;

- (void) addSavedGame:(NSDictionary*)blackCard;
+ (GameCache*) sharedCache;
@end
