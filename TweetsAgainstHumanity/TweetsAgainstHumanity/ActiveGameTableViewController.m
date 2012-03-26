//
//  ActiveGameTableViewController.m
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActiveGameTableViewController.h"
#import "TwitterCache.h"
#import "GameParameters.h"
#import "ChooseWhiteViewController.h"
#import "CreateGameViewController.h"
#import "ImageCache.h"
#import "GameStatusViewController.h"

#import "AppDelegate.h"

#import <Twitter/Twitter.h>

#define BLACK_SECTION 0
#define WHITE_SECTION 1
#define DONE_SECTION 2
#define HELP_SECTION 3

@implementation ActiveGameTableViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFromServer:) name:eTweetsUpdated object:[TwitterCache sharedCache]];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFromServer:) name:eTweetsUpdated object:[TwitterCache sharedCache]];
    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFromServer:) name:eTweetsUpdated object:[TwitterCache sharedCache]];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Server Responses

- (void) changeFromServer:(NSNotification*)note {
    [self.tableView reloadData];
}

#pragma mark Number of Rows

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == BLACK_SECTION)
        return [[TwitterCache sharedCache].blackCards count];
    if (section == WHITE_SECTION)
        return [[TwitterCache sharedCache].myGames count] + 1;
    if (section == DONE_SECTION)
        return 0;
    if (section == HELP_SECTION)
        return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

#pragma mark Cells

- (UITableViewCell *) whiteCardForIndexPath:(NSIndexPath*)indexPath
{
    int row = indexPath.row;
    
    UITableViewCell* cell = nil;
    if (row >= [[TwitterCache sharedCache].myGames count]) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = @"Create Game";
        return cell;
    } else {
        
        NSDictionary* game = [[TwitterCache sharedCache].myGames objectAtIndex:row];
        
        NSString* gameId = [game objectForKey:@"GAMEID"];
        NSString* cardId = [game objectForKey:@"CARDID"];
        
        NSString* cardText = [[GameParameters sharedParameters] getBlackCardForId:[cardId intValue]];
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",gameId,cardText];
        return cell;
    }
}

- (UITableViewCell *) blackCardForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    NSDictionary* card = nil; 
    if ([[TwitterCache sharedCache].blackCards count] > indexPath.row)
        card = [[TwitterCache sharedCache].blackCards objectAtIndex:indexPath.row];
    if (card == nil) card = [NSDictionary dictionary];
    
    cell.imageView.image = [[ImageCache sharedCache] imageForURL:[card senderImage]];
    cell.textLabel.text = [card cardText];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == BLACK_SECTION) {
        return [self blackCardForIndexPath:indexPath];
    } else if (section == WHITE_SECTION) {
        return [self whiteCardForIndexPath:indexPath];
    } else if (section == HELP_SECTION) {
        if (row == 0) {
            UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HelpCell"];
            [cell.textLabel setText:@"Help"];
            return cell;
        } else if (row == 1) {
            UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SuggestionCell"];
            [cell.textLabel setText:@"Suggestions"];
            return cell;
        }
    }
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    return cell;
}

#pragma mark Actions

- (void) askForHelp
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:GETTEXT(@"HELP")];
    [[AppDelegate sharedDelegate].rootViewController presentModalViewController:twitter animated:YES];
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        // Dismiss the controller
        [[AppDelegate sharedDelegate].rootViewController  dismissModalViewControllerAnimated:YES];
    };
}

- (void) suggestion
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:GETTEXT(@"SUGGESTION")];
    [[AppDelegate sharedDelegate].rootViewController presentModalViewController:twitter animated:YES];
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        // Dismiss the controller
        [[AppDelegate sharedDelegate].rootViewController dismissModalViewControllerAnimated:YES];
    };
}

- (void) startGameWithBlackCard:(NSDictionary*)card
{
    ChooseWhiteViewController* viewController = [[ChooseWhiteViewController alloc] initWithNibName:@"ChooseWhiteViewController" bundle:nil];
    viewController.blackCard = card;
    [[AppDelegate sharedDelegate].rootViewController presentModalViewController:viewController animated:YES];
}

- (void) gameStatus:(int)row
{
    NSDictionary* gameData = [[[TwitterCache sharedCache] myGames] objectAtIndex:row];
    
    GameStatusViewController* viewController = [[GameStatusViewController alloc] initWithNibName:@"GameStatusViewController" bundle:nil];
    viewController.gameData = gameData;
    [[AppDelegate sharedDelegate].rootViewController presentModalViewController:viewController animated:YES];
}

- (void) createGame
{
    CreateGameViewController* viewController = [[CreateGameViewController alloc] initWithNibName:@"CreateGameViewController" bundle:nil];
    [[AppDelegate sharedDelegate].rootViewController presentModalViewController:viewController animated:YES];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    if (section == BLACK_SECTION) {
        NSDictionary* card = [[TwitterCache sharedCache].blackCards objectAtIndex:row];
        [self startGameWithBlackCard:card];
    } else if (section == WHITE_SECTION) { 
        if (row >= [[TwitterCache sharedCache].myGames count])
            [self createGame];
        else
            [self gameStatus:row];
    } else if (section == HELP_SECTION) {
        if (row == 0) {
            [self askForHelp];
        } else {
            [self suggestion]; 
        }
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
}

#pragma mark Sections

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == BLACK_SECTION)
        return GETTEXT(@"AVAILABLE");
    if (section == WHITE_SECTION)
        return GETTEXT(@"MYGAMES");
    if (section == DONE_SECTION)
        return GETTEXT(@"FINISH");
    if (section == HELP_SECTION)
        return @" ";
    return @"";
}// fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}


@end
