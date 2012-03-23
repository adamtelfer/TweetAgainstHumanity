//
//  AppDelegate.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIViewController* rootViewController;
}


+ (AppDelegate*) sharedDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController* rootViewController;

- (void) changeToViewController:(UIViewController*)viewController;

@end
