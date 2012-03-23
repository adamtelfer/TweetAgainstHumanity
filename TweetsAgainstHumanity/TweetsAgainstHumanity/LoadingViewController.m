//
//  LoadingViewController.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameParameters.h"
#import "LoadingViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "TwitterCache.h"
#import "GameCache.h"
#import <Twitter/Twitter.h>

@implementation LoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelectorInBackground:@selector(_loadingGame) withObject:nil];
    
}

- (void) _loadingGame
{
    [GameParameters sharedParameters];
    [GameCache sharedCache];
    [self performSelectorOnMainThread:@selector(_finishGame) withObject:nil waitUntilDone:NO];
}

- (void) _finishGame
{
    if (![TWTweetComposeViewController canSendTweet]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Required" message:@"Login to Twitter in your Settings App" delegate:nil cancelButtonTitle:@"Shiiiiit.." otherButtonTitles:nil];
        
        [alertView show];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_startGame) name:eTweetsUpdated object:nil];
        [TwitterCache sharedCache];
    }
}

- (void) _startGame
{
    [[AppDelegate sharedDelegate] changeToViewController:
     [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]
    ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
