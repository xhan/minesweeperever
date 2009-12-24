//
//  MineSweeperEverAppDelegate.m
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright xu han 2009. All rights reserved.
//

#import "MineSweeperEverAppDelegate.h"
#import "NewGameViewController.h"
#import "StorageCenter.h"

@implementation MineSweeperEverAppDelegate

@synthesize navigationC;
@synthesize moviePlayer;
@synthesize newGameVC;
@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	
//	[window addSubview:newGameVC.view];
    [window makeKeyAndVisible];
	
	// Register to receive a notification that the movie is now in memory and ready to play
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePreloadDidFinish:) 
												 name:MPMoviePlayerContentPreloadDidFinishNotification 
											   object:nil];
	
	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
	

	if ([[StorageCenter singleton] checkDefault]) {
		[self moviePlayBackDidFinish:nil];
	}else {
		[self playOpeningMovie];
	}
	
	
//	 test storageCenter codes passed
//	NSLog(@"is in top10 %d",[[StorageCenter singleton] isRankInTop10:50 Level:0]) ;
	NSLog(@"%@",[[StorageCenter singleton].defaults objectForKey:@"level0"]);
//	[[StorageCenter singleton] insertRank:200 name:@"god" date:[NSDate date] atLevel:0];
//	NSLog(@"%@",[[StorageCenter singleton].defaults objectForKey:@"level0"]);
	
}


- (void)dealloc {
    [navigationC release], navigationC = nil;
    [moviePlayer release], moviePlayer = nil;
    [newGameVC release], newGameVC = nil;
    [window release];
	
	// remove all movie notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerContentPreloadDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
	
    [super dealloc];
}

-(void)playOpeningMovie
{
	NSURL* url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"snip" ofType:@"m4v"] ];
	MPMoviePlayerController* mp = [[MPMoviePlayerController alloc] initWithContentURL:url];
	self.moviePlayer = mp;
	[mp release];
	
//	moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
	moviePlayer.movieControlMode = MPMovieControlModeDefault;
	moviePlayer.backgroundColor = [UIColor blackColor];
	[self.moviePlayer play];
}


//  Notification called when the movie finished preloading.
- (void) moviePreloadDidFinish:(NSNotification*)notification
{
	/* 
	 < add your code here >
	 
	 MPMoviePlayerController* moviePlayerObj=[notification object];
	 etc.
	 */
//	NSLog(@"preload!");
}

//  Notification called when the movie finished playing.
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
	NSLog(@"end!");
	newGameVC = [[NewGameViewController alloc] init];	
	navigationC = [[UINavigationController alloc] initWithRootViewController:newGameVC];
	
	[window addSubview:navigationC.view];	
}

@end



