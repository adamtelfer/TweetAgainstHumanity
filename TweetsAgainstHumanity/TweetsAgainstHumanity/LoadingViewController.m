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
    [TwitterCache sharedCache];
    [self performSelectorOnMainThread:@selector(_finishGame) withObject:nil waitUntilDone:NO];
}

- (void) _finishGame
{
    if (![[TwitterCache sharedCache] isLoggedIn]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Required" message:@"This game doesn't work without twitter" delegate:nil cancelButtonTitle:@"Shiiiiit.." otherButtonTitles:nil];
        
        [alertView show];
    } else {
        [[AppDelegate sharedDelegate] changeToViewController:
        [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil]
     ];
    }
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
