//
//  GameParameters.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameParameters.h"
#import "NSDictionary+XMG.h"

@implementation GameParameters

@synthesize gameText;

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
        NSString *thePath = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"plist"];
        self.gameText = [[NSDictionary alloc] initWithContentsOfFile:thePath];
        thePath = [[NSBundle mainBundle] pathForResource:@"responses" ofType:@"plist"];
        responses = [[NSArray alloc] initWithContentsOfFile:thePath];
        thePath = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
        categories = [[NSArray alloc] initWithContentsOfFile:thePath];
    }
    return self;
}

- (int) getBlackCardInd:(NSString*)card
{
    int i = 0;
    for (NSString* w in categories) {
        if ([w isEqualToString:card]) {
            return i;
        }
        i++;
    }
    return 0;
}

- (int) getWhiteCardInd:(NSString*)whiteCard
{
    int i = 0;
    for (NSString* w in responses) {
        if ([w isEqualToString:whiteCard]) {
            return i;
        }
        i++;
    }
    return 0;
}

- (NSString*) getRandomWhiteCard:(int)seed
{
    int ind = rand() % [responses count];
    return [responses objectAtIndex:ind];
}

- (NSString*) getBlackCardForId:(int)ind
{
    if (ind < 0 || ind >= [categories count]) return [categories objectAtIndex:0];
    return [categories objectAtIndex:ind];
}

- (NSString*) getRandomBlackCard:(int)seed
{
    int ind = rand() % [categories count];
    return [categories objectAtIndex:ind];
}

- (NSString*) getTextForKey:(NSString *)key
{
    NSObject* obj = [self.gameText objectForKey:key];
	if ([obj isKindOfClass:[NSArray class]]) {
		NSArray* arr = (NSArray*)obj;
		int ind = rand() % [arr count];
		return [arr objectAtIndex:ind];
	} else {
		return obj;
	}
}

- (void) dealloc {
    responses = nil;
    categories = nil;
}

@end
