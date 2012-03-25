//
//  CreateGameViewController.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateGameViewController.h"
#import "TwitterCache.h"
#import "GameParameters.h"
#import "AppDelegate.h"

#import "GameCache.h"
#import "FriendViewController.h"

#import <Twitter/Twitter.h>

@implementation CreateGameViewController

@synthesize blackCardLabel, whiteCardLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc{
    friendController = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) randomBlackCard {
    blackCard = [[GameParameters sharedParameters] getRandomBlackCard:0];
    blackCardLabel.text = blackCard;
    
    whiteCardLabel.text = [[GameParameters sharedParameters] getRandomWhiteCard:0];
}

- (IBAction) refresh:(id)sender
{
    [self randomBlackCard];
}

- (IBAction) addFriend:(id)sender
{
    friendController = [[FriendViewController alloc] initWithNibName:@"FriendViewController" bundle:nil];
    [self.view addSubview:friendController.view];
}
- (IBAction) send:(id)sender
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    NSDictionary* gameData = [[TwitterCache sharedCache] dataForCreateGame:blackCard];
    NSString* tweetText = [gameData objectForKey:@"TWEET"];
    
    [twitter setInitialText:tweetText];
    [self presentModalViewController:twitter animated:YES];
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        // Dismiss the controller
        if (result == TWTweetComposeViewControllerResultDone) {
            [[GameCache sharedCache] addSavedGame:gameData];
            [self  dismissModalViewControllerAnimated:NO];
            [[AppDelegate sharedDelegate].rootViewController dismissModalViewControllerAnimated:YES];
        } else {
            [self  dismissModalViewControllerAnimated:YES];
        } 
    };
}

- (IBAction) cancel:(id)sender
{
    [[AppDelegate sharedDelegate].rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self randomBlackCard];
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
