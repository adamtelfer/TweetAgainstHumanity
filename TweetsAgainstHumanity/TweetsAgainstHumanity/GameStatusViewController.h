//
//  GameStatusViewController.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameStatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* twitterResponses;
}

@property (strong) NSDictionary* gameData;

@property (strong) IBOutlet UINavigationBar* navBar;
@property (strong) IBOutlet UILabel* blackCard;
@property (strong) IBOutlet UITableView* responses;


- (IBAction) close:(id)sender;

- (IBAction) refresh:(id)sender;

@end
