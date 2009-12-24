//
//  HighScoreViewController.h
//  MineSweeperEver
//
//  Created by xu xhan on 12/8/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HighScoreViewController : UIViewController<UITableViewDataSource> {
	IBOutlet UITableView* tableView;
	int _level;
	
}

-(IBAction)changeIndex:(id)sender;

@end
