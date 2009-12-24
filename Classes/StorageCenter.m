//
//  StorageController.m
//  MineSweeperEver
//
//  Created by xu xhan on 12/4/09.
//  Copyright 2009 xu han. All rights reserved.
//

#import "StorageCenter.h"
#import "GTMObjectSingleton.h"

#define DEFAULT_NAME @"MineSweeperEverConfig"
@implementation StorageCenter

GTMOBJECT_SINGLETON_BOILERPLATE(StorageCenter,singleton)

@synthesize defaults = _defaults;
@dynamic totalPlayCount,sweepBombCount,cancelCount,winCount;

#pragma mark -
#pragma mark dynamic properties

-(void)setInt:(int)value forKey:(NSString*)key
{
	[self.defaults setValue:[NSNumber numberWithInt:value] forKey:key];
}

-(int)getIntByKey:(NSString*)key
{
	return [[self.defaults valueForKey:key] intValue];
}

-(void)setTotalPlayCount:(int)count{
	[self setInt:count forKey:@"totalPlayCount"];
}

-(int)totalPlayCount{
	return [self getIntByKey:@"totalPlayCount"];
}

-(void)setSweepBombCount:(int)value{
	[self setInt:value forKey:@"sweepBombCount"];
}

-(int)sweepBombCount{
	return [self getIntByKey:@"sweepBombCount"];
}

-(void)setCancelCount:(int)value{
	[self setInt:value forKey:@"cancelCount"];
}

-(int)cancelCount{
	return [self getIntByKey:@"cancelCount"];
}

-(void)setWinCount:(int)count
{
	[self setInt:count forKey:@"winCount"];
}

-(int)winCount{
	return [self getIntByKey:@"winCount"];
}



-(BOOL)checkDefault
{
	NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
	self.defaults = [NSMutableDictionary dictionaryWithDictionary:[userDefault dictionaryForKey:DEFAULT_NAME]];
	
	if (!_defaults || [_defaults count] == 0) {
		[self writeDefault];
		return NO;
	}
	else {
//		NSLog(@"---%@",self.defaults);
		return YES;
	}

	
}

-(void)writeDefault
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"plist"];
	NSDictionary* dic =  [NSMutableDictionary dictionaryWithContentsOfFile:path];
	self.defaults = [NSMutableDictionary dictionaryWithDictionary:dic];
	[self update];

}

-(void)update
{
	if(!self.defaults)
		[NSException raise:@"user default load error" format:@"nil"];
	
	[[NSUserDefaults standardUserDefaults] setObject:self.defaults forKey:DEFAULT_NAME];
	[[NSUserDefaults standardUserDefaults] synchronize];	
}

-(void)insertRank:(int)time name:(NSString*)name date:(NSDate*)date atLevel:(int)level
{
	if ([self isRankInTop10:time Level:level]) {
		NSString* levelKey = [NSString stringWithFormat:@"level%d",level];
		NSMutableArray* newRankList = [NSMutableArray arrayWithCapacity:10];
		NSArray* rankList = [self.defaults objectForKey:levelKey];		
		BOOL insertTag = YES;
		for (int i = 0,j=0; j< 10; j++) {
			if ([[[rankList objectAtIndex:i] objectForKey:@"time"] intValue] > time && insertTag) {
				NSMutableDictionary* dic = [NSMutableDictionary dictionary];
				[dic setObject:name forKey:@"name"];
				[dic setObject:date forKey:@"date"];
				[dic setObject:[NSNumber numberWithInt:time] forKey:@"time"];
				[newRankList addObject:dic];
				insertTag = NO;
					
			}else{
				[newRankList addObject:[rankList objectAtIndex:i]];
				i++;
			}
										
		}
		[self.defaults setValue:newRankList forKey:levelKey];
		[self update];
	}
}

-(BOOL)isRankInTop10:(int)rank Level:(int)level
{
	NSString* levelKey = [NSString stringWithFormat:@"level%d",level];
	NSArray* rankList = [self.defaults objectForKey:levelKey];
	return rank < [[[rankList lastObject] objectForKey:@"time"] intValue];
}

@end
