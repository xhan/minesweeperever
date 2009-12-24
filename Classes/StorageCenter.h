//
//  StorageController.h
//  MineSweeperEver
//
//  Created by xu xhan on 12/4/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StorageCenter : NSObject {
	//contains highscores
	//beginer ,medium ,expecter,custom
	//name -- time -- (play date)
	//total counts , success counts ,total times , bomb count,
	//扫出雷数,炸死次数,放弃次数
	NSMutableDictionary* _defaults;
	
}

// update by your self in following properties
@property(nonatomic,retain)NSDictionary* defaults;
@property(nonatomic,assign)int totalPlayCount;
@property(nonatomic,assign)int sweepBombCount;
@property(nonatomic,assign)int cancelCount;
@property(nonatomic,assign)int winCount;


-(BOOL)checkDefault;

-(void)writeDefault;

-(BOOL)isRankInTop10:(int)rank Level:(int)level;

-(void)insertRank:(int)time name:(NSString*)name date:(NSDate*)date atLevel:(int)level;

-(void)update;

+ (StorageCenter*)singleton;

-(void)setInt:(int)value forKey:(NSString*)key;
-(int)getIntByKey:(NSString*)key;


@end
