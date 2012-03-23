//
//  MainViewController.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActiveGameTableViewController;

@interface MainViewController : UIViewController

@property (retain) IBOutlet ActiveGameTableViewController* activeGameController;

- (IBAction) refresh:(id)sender;

@end
