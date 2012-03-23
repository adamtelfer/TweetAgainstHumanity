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

#import "AppDelegate.h"

#import <Twitter/Twitter.h>

#define BLACK_SECTION 0
#define WHITE_SECTION 1
#define DONE_SECTION 2
#define HELP_SECTION 3

@implementation ActiveGameTableViewController

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
        return 0;
    if (section == DONE_SECTION)
        return 0;
    if (section == HELP_SECTION)
        return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

#pragma mark Cells

- (UITableViewCell *) blackCardForIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int row = indexPath.row;
    int section = indexPath.section;
    
    if (section == BLACK_SECTION) {
        return [self blackCardForIndexPath:indexPath];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    if (section == BLACK_SECTION) {
        
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
}// fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}


@end
