//
//  ImageCache.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

static ImageCache* _cache = nil;

+ (ImageCache*) sharedCache {
    if (_cache == nil) {
        _cache = [[ImageCache alloc] init];
    }
    return _cache;
}

- (id) init {
    self = [super init];
    if (self) {
        images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (UIImage*) imageForURL:(NSURL*)url
{
    UIImage* image = [images objectForKey:url];
    if (image == nil) {
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
        [images setObject:image forKey:url];
    }
    return image;
}

@end
