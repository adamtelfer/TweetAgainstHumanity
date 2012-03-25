//
//  ImageCache.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject
{
    NSMutableDictionary* images;
}

+ (ImageCache*) sharedCache;

- (UIImage*) imageForURL:(NSURL*)url;


@end
