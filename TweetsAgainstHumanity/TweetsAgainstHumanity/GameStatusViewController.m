//
//  GameStatusViewController.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatusViewController.h"
#import "AppDelegate.h"
#import "GameParameters.h"
#import "TwitterCache.h"
#import "AppDelegate.h"

#import <Twitter/Twitter.h>

@implementation GameStatusViewController

@synthesize navBar, blackCard, responses, gameData;

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

#pragma mark Table Components

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* tweet = [twitterResponses objectAtIndex:indexPath.row];
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    NSString* tweetText = @"#TAH #2000000 @username Won!";//[[TwitterCache sharedCache] tweetForFinishGame:tweet onBlackCard:gameData];
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
    return [twitterResponses count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    tableCell.textLabel.text = @"";
    
    if ([twitterResponses count] > indexPath.row) {
        NSDictionary* tweet = [twitterResponses objectAtIndex:indexPath.row];
        NSDictionary* tweetData = [tweet gameId];
        
        NSString* cardId = [tweetData objectForKey:@"CARDID"];
        NSString* cardText = [[GameParameters sharedParameters] getWhiteCardForId:[cardId intValue]];
        
        tableCell.textLabel.text = [NSString stringWithFormat:@"@%@ : %@",
                                    [tweet senderUsername],
                                    cardText];
    }
    
    return tableCell;
}

#pragma mark - View lifecycle

- (void) _displayTwitterData {
    
    NSString* gameId = [gameData objectForKey:@"GAMEID"];
    
    twitterResponses = [[TwitterCache sharedCache].whiteCards objectForKey:gameId];
    NSLog(@"%@ : %d Responses",gameId,[twitterResponses count]);
    
    [responses reloadData];
    
    NSString* cardId = [gameData objectForKey:@"CARDID"];
    NSString* cardText = [[GameParameters sharedParameters] getBlackCardForId:[cardId intValue]];
    NSString* formattedString = cardText;
    formattedString = [formattedString stringByReplacingOccurrencesOfString:@"_" withString:@"__________"];
    self.blackCard.text = formattedString;
}

- (void) _performTwitterRequest {
    [[TwitterCache sharedCache] refresh];
    [self performSelectorOnMainThread:@selector(_displayTwitterData) withObject:nil waitUntilDone:YES];
}

- (void) refreshTwitterData {
    [self performSelectorInBackground:@selector(_performTwitterRequest) withObject:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    twitterResponses = [NSArray array];
    
    self.blackCard.text = @"";
    
    [self refreshTwitterData];
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

#pragma mark Buttons

- (IBAction) close :(id)sender
{
    [[AppDelegate sharedDelegate].rootViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction) refresh:(id)sender
{
    [self refreshTwitterData];
}

@end
