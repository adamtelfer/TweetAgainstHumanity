//
//  XMGMacros.h
//  XMGLib
//
//  Created by Andrew Toth on 7/28/10.
//  Copyright 2010 XMG Studio Inc. All rights reserved.
//

// will nil the pointer after releasing
#define NIL_RELEASE(object) [object release], object = nil;

// will assert that the object gets deleted
#ifndef DEBUG
#define ASSERT_DEALLOC(object) NIL_RELEASE (object)
#else
#define ASSERT_DEALLOC(object) if ([object retainCount] > 1) XMGAssert(NO,@"Assert Release Failed!"); else NIL_RELEASE(object);
#endif

#ifndef DEBUG
#define ASSERT_RELEASE_COUNT(object,n) NIL_RELEASE (object)
#else
#define ASSERT_RELEASE_COUNT(object,n) if ([object retainCount] > n + 1) { XMGAssert(NO,@"Assert Release Failed!"); } else { NIL_RELEASE(object); }
#endif

#ifndef DEBUG
#define XMGLog(message, ...) 
#else
#define XMGLog(message, ...) CFShow([NSString stringWithFormat:message,##__VA_ARGS__])
#endif

#ifndef DEBUG
#define XMGAssert(check,message, ...) //\
//    if (!(check)) { \
//        [XMGAnalytics logError:[NSString stringWithUTF8String: __FILE__ ] message:[NSString stringWithFormat:message, ##__VA_ARGS__ ] exception:[NSException exception]]; \
//    }
#else
#define XMGAssert(check,message, ...) if (!(check)) { NSLog(@"*****"); NSLog(@"***XMG ASSERTION ERROR***"); NSLog(@"File : %s | Func : %s | Line : %d",__FILE__,__PRETTY_FUNCTION__,__LINE__); NSLog(message, ##__VA_ARGS__ ); NSLog(@"*****"); assert(false);  }
#endif

#pragma mark Random Number Helpers
#define RANDF (arc4random() % 10000 / 10000.f)
#define RANDOM_FLOAT(min,max) ((min) + RANDF * ((max)-(min)))
#define RANDOM_INT(min,max) ((arc4random() % ((max)-(min))) + (min))
#define RANDOM_PROBABILITY(prob) (arc4random() % 1000 < ((int)(1000 * (prob))))

/*
 *  Listener helper macros
 */
#define ADD_METHOD_LISTENER(key, obj, sel, from) \
    if([obj respondsToSelector:@selector(sel)]) { \
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(sel) name:key object:from]; \
    } 
#define REMOVE_LISTENER(obj) \
    [[NSNotificationCenter defaultCenter] removeObserver:obj]
#define REMOVE_METHOD_LISTENER(key, obj, from) \
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:key object:from]
#define NOTIFY_LISTENERS(key, info) \
    [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:info]
#define NOTIFY_LISTENERS_FROM(from, key, info) \
    [[NSNotificationCenter defaultCenter] postNotificationName:key object:from userInfo:info]

#ifdef DEBUG
#define PRODUCT_SERVER_URL [NSString stringWithFormat:@"http://www.xmg.com/staging/%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]]
#else
#define PRODUCT_SERVER_URL [NSString stringWithFormat:@"http://www.xmg.com/update/%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey]]
#endif

#define IS_IPAD_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_RETINA_DISPLAY (!IS_IPAD_DEVICE && [UIScreen instancesRespondToSelector:@selector(scale)] && [UIScreen mainScreen].scale == 2.f)

#define STRING_UIInterfaceOrientationIsPortrait(orientation)  ([(orientation) isEqualToString:@"UIInterfaceOrientationPortrait"] || [(orientation) isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"])
#define STRING_UIInterfaceOrientationIsLandscape(orientation) ([(orientation) isEqualToString:@"UIInterfaceOrientationLandscapeLeft"] || [(orientation) isEqualToString:@"UIInterfaceOrientationLandscapeRight"])
