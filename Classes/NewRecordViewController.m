//
//  NewRecordViewController.m
//  MineSweeperEver
//
//  Created by xu xhan on 12/9/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import "NewRecordViewController.h"
#import "StorageCenter.h"

@implementation NewRecordViewController

@synthesize date;


-(id)initWithLevel:(int)alevel date:(NSDate*)adate time:(int)times
{
	self = [super init];
	level = alevel;
	time = times;
	self.date = adate;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	[nameField becomeFirstResponder];
	scoreLabel.text = [NSString stringWithFormat:@"%.1f",time/10.0];
}




- (void)dealloc {
    [date release], date = nil;
    [super dealloc];
}



#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	//TODO: add default user && add empty user name check
	[[StorageCenter singleton] insertRank:time name:nameField.text date:date atLevel:level];
	[self dismissModalViewControllerAnimated:YES];
	return NO;
}

@end

