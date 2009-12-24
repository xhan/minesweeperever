//
//  NewGameViewController.m
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import "NewGameViewController.h"
#import "GameStageViewController.h"
#import "HighScoreViewController.h"
#import "MineSweeperEverAppDelegate.h"

@implementation NewGameViewController

//cols, rows,mines
int gameLevelDetail[4][3]={
	{10,10,14},
//	{4,4,4},
	{16,16,40},
	{18,28,88},
	{18,28,88}
};

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	self.navigationController.navigationBarHidden = NO; 
//	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.title = @"MineSweeper Ever!";
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	AdMobView *ad = [AdMobView requestAdWithDelegate:self]; // start a new ad request
    ad.frame = CGRectMake(0, 368, 320, 48); // set the frame, in this case at the bottom of the screen
    [self.view addSubview:ad]; // attach the ad to the view hierarchy; self.window is responsible for retaining the ad
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(IBAction)setupGameLevel:(id)sender
{
	UISegmentedControl* con = (UISegmentedControl*)sender;
	_GameLevel =  con.selectedSegmentIndex ;
	
}

-(IBAction)startGame:(id)sender
{
	GameStageViewController* gameStageVC = [[GameStageViewController alloc] initWithCols:gameLevelDetail[_GameLevel][0]
																					Rows:gameLevelDetail[_GameLevel][1]
																				   level:_GameLevel 
																				   mines:gameLevelDetail[_GameLevel][2]];
//	[self.navigationController pushViewController:gameStageVC animated:NO];
	
	[self presentModalViewController:gameStageVC animated:NO];
	[gameStageVC release];
}


-(IBAction)onHighScore:(id)sender
{
	[self.navigationController pushViewController:[[HighScoreViewController new] autorelease] animated:YES];	
}

-(IBAction)onPlayMovie:(id)sender
{
	MineSweeperEverAppDelegate* delegate = [UIApplication sharedApplication].delegate;
	[delegate playOpeningMovie];
}

#pragma mark -
#pragma mark admob

- (NSString *)publisherId
{
	return @"a14b1f88fc5a608";
}

/*
- (BOOL)useTestAd {
	return YES;
}
*/
@end
