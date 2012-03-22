//
//  GameParameters.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameParameters : NSObject

+ (GameParameters*) sharedParameters;

@property (retain) NSArray* responses;
@property (retain) NSArray* categories;

@end
