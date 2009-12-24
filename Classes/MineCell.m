//
//  MineCell.m
//  MineSweeperEver
//
//  Created by xu xhan on 12/3/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import "MineCell.h"
#import "GameStageViewController.h"

@implementation MineCell

@dynamic displayType;
@synthesize isBomb;
@synthesize label , x,y;


-(id)init{
	if (self = [super initWithFrame:CGRectMake(0, 0, CELL_MAX_WIDTH, CELL_MAX_WIDTH)]) {
		self.userInteractionEnabled = YES;
		if (!label) {
			label = [[UILabel alloc] initWithFrame:CGRectInset(self.frame, 2, 2)];
			label.font = [UIFont systemFontOfSize:22];	
			label.backgroundColor = [UIColor clearColor];
			label.textAlignment = UITextAlignmentCenter;
			label.center = self.center;
			[self addSubview:label];
			
		}
		[self setDisplayType:MineNotSelected];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}





- (void)dealloc {
    [label release], label = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Public
-(void)setupAsMine
{
	isBomb = YES;
}



-(void)setDisplayNumber:(int)number
{
	label.hidden = NO;
	label.text = [NSString stringWithFormat:@"%d",number];
	[self setDisplayType:MineSelectedEmpty];
	_displayType = MineSelectedNumber;
}

-(MineSelectType)displayType
{
	return _displayType;
}

-(void)setDisplayType:(MineSelectType)atype
{
	
	switch (atype) {
		case MineNotSelected:{
			self.image = [UIImage imageNamed:@"cell_normal.png"];
//			[label removeFromSuperview];
//			[label release] , label = nil;
			label.hidden = YES;
		}			
			break;

		case MineWithFlag:
			self.image = [UIImage imageNamed:@"cell_flag.png"];
			break;
		case MineSelectedEmpty:
			self.image = [UIImage imageNamed:@"cell_digged.png"];
			break;
		case MineIsBomb:
			self.image = [UIImage imageNamed:@"cell_bomb.png"];
			break;
		case MineIsBombWrong:
			self.image = [UIImage imageNamed:@"cell_bomb_error.png"];
			break;
		case MineWithFlagWrong:
			self.image = [UIImage imageNamed:@"cell_flag_error.png"];
			break;
	


		default:
			break;
	}
	_displayType = atype;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//	CGPoint pt = [[touches anyObject] locationInView:self];
	//TODO : check if touch end inside the view;
	[(GameStageViewController*)[self viewController] onCellClicked:self];
}


-(BOOL)setAsFlag:(BOOL)flag
{
	if (flag) {
		if (self.displayType == MineNotSelected ) {
			[self setDisplayType:MineWithFlag];
			return YES;
		}
		else {
			return NO;
		}		
	}else {
		if (self.displayType == MineWithFlag) {
			[self setDisplayType:MineNotSelected];
			return YES;
		}
		return NO;
	}



}


-(BOOL)isSelectedRight
{
	if (self.isBomb && self.displayType == MineWithFlag) {
		return YES;
	}
	if (!self.isBomb && self.displayType != MineNotSelected) {
		return YES;
	}
	return NO;
}

@end



