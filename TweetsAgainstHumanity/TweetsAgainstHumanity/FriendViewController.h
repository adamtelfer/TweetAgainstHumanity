//
//  FriendViewController.h
//  TweetsAgainstHumanity
//
//  Created by XMG Studio on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray* friendArray;
}

@property (strong) IBOutlet UITableView* tableView;

- (IBAction) cancel:(id)sender;

@end
