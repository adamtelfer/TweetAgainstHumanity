//
//  ChooseWhiteViewController.h
//  TweetsAgainstHumanity
//
//  Created by Adam Telfer on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseWhiteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    @private
    NSArray* whiteCards;
}
@property (strong) NSDictionary* blackCard;

@property (strong) IBOutlet UILabel* blackCardLabel;

@property (strong) IBOutlet UITableView* whiteCardTable;

- (IBAction) back:(id)sender;

@end
