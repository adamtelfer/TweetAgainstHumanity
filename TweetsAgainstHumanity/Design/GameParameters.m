//
//  GameParameters.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameParameters.h"

@implementation GameParameters

@synthesize responses, categories;

static GameParameters* _parameters;

+ (GameParameters*) sharedParameters {
    if (_parameters == nil) {
        _parameters = [[GameParameters alloc] init];
    }
    return _parameters;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        self.responses = [[NSArray alloc] initWithContentsOfFile:@"responses.plist"];
        self.categories = [[NSArray alloc] initWithContentsOfFile:@"categories.plist"];
    }
    return self;
}

- (void) dealloc {
    self.responses = nil;
    self.categories = nil;
}

@end
