//
//  GameStageViewController.m
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import "GameStageViewController.h"
#import "MineCell.h"
#import "StorageCenter.h"
#import "NewRecordViewController.h"


@implementation GameStageViewController

@synthesize containerView = _containerView;

int nearPos[8][2] ={
	{-1,-1},	{-1,0}, 	{-1,1},
	{0,-1},					{0,1},
	{1,-1},		{1,0},		{1,1}
};


- (void)dealloc {
	[_timer invalidate], [_timer release], _timer = nil;
	[_containerView release], _containerView = nil;
	[_scrollView release], _scrollView = nil;
	[bombs release] , bombs = nil;
    [super dealloc];
}

-(id)initWithCols:(int)cols Rows:(int)rows level:(int)level mines:(int)mines
{
	if (self = [super init]) {
		_cols = cols;
		_rows = rows;
		_level = level;
		bombs = [[NSMutableArray alloc] initWithCapacity:(_cols * _rows)];
		_mines = mines;		
		
	}
	return self;
}

-(void)restartGame
{
	_usedTime = 0;	
	_isInFlag = NO;
	_usedflags = _mines;
	
	//clean mine display types
	for (MineCell* cell in bombs) {
		cell.displayType = MineNotSelected;
		cell.isBomb = NO;
	}
	
	[self placeBombs];
	[_scrollView setZoomScale:0.8];
	[self updateFlagsItem];
}


-(BOOL)gotoGameState:(GameState)state
{
	/*
	if (state == _gameState) {
		return NO;
	}
	*/
	BOOL changeTag = YES;
	
	switch (state) {
		case GameStateInit:
		{
			[self restartGame];
		}
			break;

		case GameStateWin:
		{
//			NSLog(@"opp win")	;
			[self alertWinMessage];
		}
			break;
		case GameStateLost:
		{
			[self alertSimpleAction];			
		}
			break;
		case GameStatePausing:
		{
			//do nothing here because we will check state on OnTimer method
			if (_gameState != GameStateRunning) {
				changeTag = NO;
			}
		}
			break;
		case GameStateRunning:
		{
			if (_gameState == GameStateInit) {
				if (_timer) {
					[_timer invalidate];
					//[_timer release],
					_timer = nil;
				}
				_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];		
				_gameState = GameStateRunning;				
			}else if(_gameState != GameStatePausing){
				changeTag = NO;
			}


		}
			break;
	
		default:
			break;
	}
	
	if(changeTag){
		_gameState = state;
		return YES;
	}

	else {
		return NO;
	}


}




-(void)updateFlagsItem
{
	if (_usedflags == 0) {
		flagsItem.title = @"No Flags Left";
		return;
	}
	
	flagsItem.title = _usedflags > 1 ? [NSString stringWithFormat:@"%d Flags Remain",_usedflags] : @"One Flag Only";
	flagsItem.style= _isInFlag ? UIBarButtonItemStyleDone : UIBarButtonItemStyleBordered ;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationController.navigationBarHidden = YES; 
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460-44)];
	_scrollView.delegate = self;
	_scrollView.minimumZoomScale = CELL_MIN_WIDTH  /(float)CELL_MAX_WIDTH ;
	_scrollView.maximumZoomScale = 1;
	
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.bounces = YES;
	_scrollView.backgroundColor = [UIColor colorWithRed:86/250.0 green:59/250.0 blue:36/250.0 alpha:1];
	[self.view addSubview:_scrollView];
	
	_containerView = [[UIView alloc] init];
	_containerView.frame = CGRectMake(0, 0, _cols*(CELL_MAX_WIDTH), _rows*(CELL_MAX_WIDTH));
	
	_scrollView.contentSize = _containerView.frame.size;
	[_scrollView addSubview:_containerView];
	
	
	MineCell* mineCell;
	for (int i=0; i<_rows; i++) {
		for (int j=0; j<_cols; j++) {
			mineCell = [MineCell new];
			mineCell.left = j* (CELL_MAX_WIDTH);
			mineCell.top = i*(CELL_MAX_WIDTH);
			mineCell.width = CELL_MAX_WIDTH;
			mineCell.height = CELL_MAX_WIDTH;
			mineCell.x = j;
			mineCell.y = i;
			[_containerView addSubview:mineCell];
			[mineCell release];
			[bombs addObject:mineCell];
		}
	}

	
	[self.view bringSubviewToFront:toolbar];
	timeLeftLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:30];
	[self.view bringSubviewToFront:timeLeftLabel];
	
	systemItem.target = self;
	flagsItem.target = self;

	
	systemItem.action = @selector(onSystemItem:);
	flagsItem.action = @selector(onFlagItem:);
	
	[self gotoGameState:GameStateInit];

}


-(void)holdAtBomb:(MineCell*)cell
{
	
}


-(void)onCellClicked:(MineCell*)cell
{
		
	if (_gameState == GameStateInit) {
		[self gotoGameState:GameStateRunning];
	}
	
	if (_gameState != GameStateRunning) {
		return;
	}
	
	// in flag state
	if (_isInFlag) {
		// convert flag to unselect
		if (cell.displayType == MineWithFlag) {
			[cell setAsFlag:NO];
			_usedflags += 1;
		//	try to convert to flag
		}else if (_usedflags > 0) {
			if([cell setAsFlag:YES])
			{
				_usedflags -=1;
				_isInFlag = NO;
			}			
		} 

		
		[self updateFlagsItem];
		[self checkGameResult];
		return;
	}
	
	if (cell.displayType == MineWithFlag || cell.displayType == MineSelectedEmpty || cell.displayType == MineSelectedNumber) {
		return;
	}
	
	if (cell.isBomb) {		
		[self clickAtBomb:cell];
	}else {
		[self exploreCellsByRowY:cell.y ColX:cell.x];
	}

	[self checkGameResult];
}

-(void)clickAtBomb:(MineCell*)cell
{

	for (MineCell* cell in bombs) {
		if (cell.isBomb && cell.displayType == MineWithFlag) {
			[cell setDisplayType:MineIsBomb];
		}
		if (!cell.isBomb && cell.displayType == MineWithFlag) {
			[cell setDisplayType:MineWithFlagWrong];
		}
	}
	[cell setDisplayType:MineIsBombWrong];
	[self gotoGameState:GameStateLost];
}


-(void)checkGameResult
{
	BOOL win = YES;
	BOOL lost = YES;
	
	for (MineCell* cell in bombs) {
		if (![cell isSelectedRight]) {
			win = NO;
		}
		if (cell.displayType == MineNotSelected) {
			lost = NO;
		}
		if (!win && !lost) {
			break;
		}
	}
	if (win) {
		[self gotoGameState:GameStateWin];
	}else {
		//this state just fit for You placed every thing, but not correctly
		//FIXME: I think it will never happend
		if(lost){
			[NSException raise:@"god happened" format:@"checkGameResult method"];
			[self gotoGameState:GameStateLost];			
		}

	}

}

//frequence 10 per-second
-(void)onTimer
{
	if (_gameState == GameStateRunning) {
		_usedTime += 1;
		if (_usedTime >= 9999) {
			[self gotoGameState:GameStateLost];
		}
		if (_usedTime % 10 == 0) {
			timeLeftLabel.text = [NSString stringWithFormat:@"%.3d",_usedTime/10];
		}
	}
	if (_gameState == GameStateInit) {
		timeLeftLabel.text = [NSString stringWithFormat:@"%.3d",_usedTime/10];
	}
}




- (void)alertWinMessage
{
	NSDate* date = [NSDate date];
	if ([[StorageCenter singleton] isRankInTop10:_usedTime Level:_level]) {
		NewRecordViewController* newRecordVC = [[NewRecordViewController alloc] initWithLevel:_level date:date time:_usedTime];
		newRecordVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController:newRecordVC animated:YES];
		[newRecordVC release];
		return;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good Job" message:[NSString stringWithFormat:@"Yups,you costs %.1f seconds",_usedTime/10.0] 
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];	
}


- (void)alertSimpleAction
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Ooops,Sweep a Bomb!\n"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _containerView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}



#pragma mark -
#pragma mark on button action
-(void)onSystemItem:(id)sender
{
	//pause timer
	UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Pause"
															 delegate:self
													cancelButtonTitle:@"Resume" 
											   destructiveButtonTitle:nil 
													otherButtonTitles:@"Back to Menu",@"Restart",nil] autorelease];
//	[actionSheet showInView:self.view];
	[actionSheet showFromToolbar:toolbar];
	[self gotoGameState:GameStatePausing];
}

-(void)onFlagItem:(id)sender
{
	
	_isInFlag = !_isInFlag;
	
	[self updateFlagsItem];
	
}

#pragma mark -
#pragma mark UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//	NSLog(@"%d",buttonIndex);
	//back
	//TODO: setup to game lost but without alert messages
	
	if (buttonIndex == 0) {
//		[self.navigationController popViewControllerAnimated:NO];
		[self dismissModalViewControllerAnimated:NO];
		return;
	}
	if (buttonIndex == 1) {
//		[self.navigationController popViewControllerAnimated:NO];
		// push again
		[self gotoGameState:GameStateInit];
	}else {
		[self gotoGameState:GameStateRunning];
	}

	
}

#pragma mark -
#pragma mark Private

-(MineCell*)getBombCellFromRowY:(int)row ColX:(int)col 
{
	
	int	index = row *_cols + col;
	
	MineCell* cell = [bombs objectAtIndex:index];
	if (row != cell.y || col != cell.x) {
		[NSException raise:@"GetBombCell Error" format:nil];
	}
	return cell;
}


-(int)findBombsNumNearByCell:(MineCell*)cell
{
	int row = cell.y;
	int col = cell.x;
	
	int num = 0;
	int new_row,new_col;
	
	for(int i=0 ; i<8 ;i++)
	{
		new_row = row +nearPos[i][0];
		new_col = col +nearPos[i][1];
		MineCell *tempCell;
		if([self vaildRowY:new_row ColX:new_col])
		{
			tempCell = (MineCell*)[self getBombCellFromRowY:new_row ColX:new_col];
			if(tempCell.isBomb)
				num+=1;
			
		}
	}
	return num;
}

-(BOOL)vaildRowY:(int)row ColX:(int)col 
{
	return (row >=0 && col >=0 && row<_rows && col<_cols);
}


-(void)exploreCellsByRowY:(int)row ColX:(int)col 
{
	
	MineCell *cell = (MineCell*)[self getBombCellFromRowY:row ColX:col];
	if(cell.displayType == MineSelectedEmpty || cell.displayType == MineSelectedNumber)
		return;
	
	int num = [self findBombsNumNearByCell:cell];
	if(num == 0)
	{
		if (cell.displayType != MineWithFlag) {
			[cell setDisplayType:MineSelectedEmpty];			
		}
		int new_row,new_col;
		for (int i = 0; i< 8; i++) {
			new_row = row +nearPos[i][0];
			new_col = col +nearPos[i][1];
			if([self vaildRowY:new_row ColX:new_col])
				[self exploreCellsByRowY:new_row ColX:new_col];
		}
	}
	else if (cell.displayType != MineWithFlag) {
		[cell setDisplayNumber:num];
	}

	
}

-(void)placeBombs
{
	int row,col;
	srandom(time(NULL));
	for(int i=0;i<_mines;i++)
	{
		MineCell *tmp;
		do{
			row = random()%_rows;
			col = random()%_cols;
			tmp = (MineCell*)[self getBombCellFromRowY:row ColX:col];
		}while(tmp.isBomb == YES);
		tmp.isBomb = YES;
	}
}

@end

