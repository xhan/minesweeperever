//
//  NewRecordViewController.h
//  MineSweeperEver
//
//  Created by xu xhan on 12/9/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewRecordViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel* scoreLabel;
	IBOutlet UITextField* nameField;
	int time,level;
	NSDate* date;
}

@property (nonatomic, retain) NSDate *date;

-(id)initWithLevel:(int)level date:(NSDate*)date time:(int)times;

@end

