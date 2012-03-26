//
//  FriendViewController.m
//  TweetsAgainstHumanity
//
//  Created by XMG Studio on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "GameParameters.h"

@implementation FriendViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)cancel:(id)sender {
    [self.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// We can move this to the twitter cache - just wasn't sure how to reference a function in another ViewController

- (void)loadFriends {
    if ([TWTweetComposeViewController canSendTweet]) 
    {
        // Create account store, followed by a twitter account identifier
        // At this point, twitter is the only account type available
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                 // Sanity check
                 if ([arrayOfAccounts count] > 0) 
                 {
                     // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                     
                     // Hard coded in the username for testing ****
                     
                     // Build a twitter request for getting ids of all your friends
                     TWRequest *getRequest = [[TWRequest alloc] initWithURL:
                                              [NSURL URLWithString:@"https://api.twitter.com/1/friends/ids.json?cursor=-1&screen_name=tagainsth"] 
                                                                 parameters:nil requestMethod:TWRequestMethodGET];
                     
                     // Post the request
                     [getRequest setAccount:acct];
                     NSLog(@"Twitter Request %@", [getRequest description]);
                     
                     
                     // Block handler to manage the response
                     [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                      {
                          NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                          
                          
                          // Testing - Json to take responeData and return string
                          if (responseData) {
                              //  Use the NSJSONSerialization class to parse the returned JSON
                              NSError *jsonError;
                              NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                                 options:NSJSONReadingMutableLeaves 
                                                                                   error:&jsonError];
                              NSLog(@"responseData %@", results);
                              
                              // adding all your friends to the object userFriends
                              if (results) {
                                  NSMutableArray* userFriends = [[NSMutableArray alloc] init];
                                      NSArray* ids = [results objectForKey:@"ids"];
                                  
                                  for (NSString* id in ids) {
                                      [userFriends addObject:id];
                                  }
                                        
                                        
                                  
                                  // adding all of the ids into a single string that can be parsed through the json request
                                  if (userFriends) {
                                      NSString* friendsString = @"";
                                    
                                      for (NSString* friend in userFriends) {
                                          friendsString = [NSString stringWithFormat:@"%@,%@",friendsString,friend];
                                          
                                          
                                          NSLog(@"%@", friend);
                                          NSLog(@"%@", friendsString);
                                      }
                                      NSLog(@"Friend %@", friendsString);
                                      // here we will have to break it up by 100's if user has more than 100 friends.
                                      NSString* url = [NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=@%@", friendsString];
                                      
                                      TWRequest *getRequest = [[TWRequest alloc] initWithURL:
                                                               [NSURL URLWithString:(url)] 
                                                                                  parameters:nil requestMethod:TWRequestMethodGET];
                                      
                                      [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                                       {
                                           
                                           NSLog(@"Got Friend Names");
                                           
                                           NSError *jsonError;
                                           NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                                                   options:NSJSONReadingMutableLeaves 
                                                                                                     error:&jsonError];
                                           
                                           
                                           NSLog(@"%@",[results description]);
                                           
                                 // Add your friends screennames to an array
                                        
                                           NSMutableArray* friendList = [[NSMutableArray alloc] init];
                                        
                                           for (NSDictionary* friends in results){
                                               
                                               [friendList addObject:[friends objectForKey:@"screen_name"]];
                                               NSLog(@"%@", friendList);
                                           }
                                           
                                            friendArray = friendList;
                                            [tableView reloadData];
                                       
                                       }];
                                      
                                      
                                  }                                      
                                  
                              }
                              

                              
                              
                          }
                      
                          
                      }];
                 }
             }
         }];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSString* friend = [friendArray objectAtIndex:indexPath.row];
    tableCell.textLabel.text = friend;
    return tableCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFriends];
    // Do any additional setup after loading the view from its nib.
}

@end
