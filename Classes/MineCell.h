//
//  MineCell.h
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MineNotSelected = 0,
	MineSelectedEmpty,
	MineSelectedNumber,
	MineWithFlag,
	BOMB_question,
	MineWithFlagWrong,
	MineIsBombWrong,
	MineIsBomb,
} MineSelectType;


@interface MineCell : UIImageView {
	MineSelectType _displayType;	
	bool isBomb;
	UILabel* label;
//	UIImageView* 
	int x,y;
}

@property (nonatomic, assign) MineSelectType displayType;
@property (nonatomic, assign) bool isBomb;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) int x,y;

-(void)setupAsMine;

-(void)setDisplayNumber:(int)number;

//-(void)setDisplayType:(MineSelectType)atype;

-(BOOL)setAsFlag:(BOOL)flag;

-(BOOL)isSelectedRight;

@end



