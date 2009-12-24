//
//  GameStageViewController.h
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CELL_MAX_WIDTH 48
#define CELL_MIN_WIDTH 24

enum GameState {
	GameStateInit,
	GameStateRunning,
	GameStatePausing,
	GameStateWin,
	GameStateLost
};
typedef int GameState;


@class MineCell;
@interface GameStageViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate> {
	int _cols, _rows;
	int _level;
	int _mines;
	NSMutableArray* bombs;
	UIScrollView* _scrollView;
	UIView * _containerView;
	
	NSTimer* _timer;
	NSDate* _startTime;
	int _usedTime;
	
	IBOutlet UILabel* timeLeftLabel;
	IBOutlet UIToolbar* toolbar;
	IBOutlet UIBarButtonItem* systemItem;
	IBOutlet UIBarButtonItem* flagsItem;
	
	int _usedflags;
	BOOL _isInFlag;
	GameState _gameState;
	
}

@property (nonatomic, retain) UIView *containerView;

-(BOOL)gotoGameState:(GameState)state;

-(void)updateFlagsItem;

-(void)checkGameResult;

-(id)initWithCols:(int)cols Rows:(int)rows level:(int)level mines:(int)mines;

-(void)onCellClicked:(MineCell*)cell;

-(void)exploreCellsByRowY:(int)row ColX:(int)col ;

- (void)alertSimpleAction;

- (void)alertWinMessage;


-(int)findBombsNumNearByCell:(MineCell*)cell;

-(MineCell*)getBombCellFromRowY:(int)row ColX:(int)col ;

-(BOOL)vaildRowY:(int)row ColX:(int)col ;

-(void)placeBombs;

-(void)clickAtBomb:(MineCell*)cell;

-(void)holdAtBomb:(MineCell*)cell;

-(void)restartGame;

@end

