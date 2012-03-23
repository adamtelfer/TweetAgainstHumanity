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

+ (GameParameters*) sharedParameters;

@property (strong) NSDictionary* gameText;

- (NSString*) getTextForKey:(NSString*)key;

@property (retain) NSArray* responses;
@property (retain) NSArray* categories;

@end
