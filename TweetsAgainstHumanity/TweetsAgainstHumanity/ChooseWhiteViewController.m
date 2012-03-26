//
//  ChooseWhiteViewController.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseWhiteViewController.h"
#import "TwitterCache.h"
#import "AppDelegate.h"
#import "GameParameters.h"

#import <Twitter/Twitter.h>

@implementation ChooseWhiteViewController

@synthesize blackCard, blackCardLabel, whiteCardTable;

- (NSString*) getRandomWhiteCard {
    return [[GameParameters sharedParameters] getRandomWhiteCard:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        whiteCards = [[NSArray alloc] initWithObjects:
                        [self getRandomWhiteCard],
                        [self getRandomWhiteCard],
                        [self getRandomWhiteCard],
                        [self getRandomWhiteCard],
                        [self getRandomWhiteCard],
                      [self getRandomWhiteCard],
                      [self getRandomWhiteCard],
                      [self getRandomWhiteCard],
                      [self getRandomWhiteCard],
                        [self getRandomWhiteCard]
                      , nil];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* whiteCard = [whiteCards objectAtIndex:indexPath.row];
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    NSString* tweetText = [[TwitterCache sharedCache] tweetForWhiteCard:whiteCard onBlackCard:blackCard];
    [twitter setInitialText:tweetText];
    
    UITableViewCell* tableCell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self presentModalViewController:twitter animated:YES];
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        // Dismiss the controller
        
        
        
        if (result == TWTweetComposeViewControllerResultDone) {
            [tableCell setSelected:NO animated:NO];
            [self  dismissModalViewControllerAnimated:NO];
            [[AppDelegate sharedDelegate].rootViewController dismissModalViewControllerAnimated:YES];
        } else {
            [tableCell setSelected:NO animated:YES];
            [self  dismissModalViewControllerAnimated:YES];
        }
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [whiteCards count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    tableCell.textLabel.text = [whiteCards objectAtIndex:indexPath.row];
    return tableCell;
}

- (IBAction) back:(id)sender
{
    [[AppDelegate sharedDelegate].rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* formattedString = [self.blackCard cardText];
   formattedString = [formattedString stringByReplacingOccurrencesOfString:@"_" withString:@"__________"];
    blackCardLabel.text = formattedString;
    
    // Do any additional setup after loading the view from its nib.
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
