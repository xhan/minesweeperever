//
//  MineSweeperEverAppDelegate.h
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright xu han 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class NewGameViewController;

@interface MineSweeperEverAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MPMoviePlayerController* moviePlayer;
	NewGameViewController* newGameVC;
	UINavigationController* navigationC;
}

@property (nonatomic, retain) UINavigationController *navigationC;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) NewGameViewController *newGameVC;
@property (nonatomic, retain) IBOutlet UIWindow *window;

-(void)playOpeningMovie;
- (void) moviePlayBackDidFinish:(NSNotification*)notification;

@end




