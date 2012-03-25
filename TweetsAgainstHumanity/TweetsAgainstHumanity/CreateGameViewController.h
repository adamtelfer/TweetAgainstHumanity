//
//  CreateGameViewController.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendViewController.h"

@interface CreateGameViewController : UIViewController {
    NSString* blackCard;
    FriendViewController* friendController;
}


@property (strong) IBOutlet UILabel* whiteCardLabel;
@property (strong) IBOutlet UILabel* blackCardLabel;

- (IBAction) refresh:(id)sender;

- (IBAction) send:(id)sender;

- (IBAction) cancel:(id)sender;

- (IBAction) addFriend:(id)sender;

@end
