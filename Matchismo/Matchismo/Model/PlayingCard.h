//
//  PlayingCard.h
//  Matchismo
//
//  Created by Nenad Kovačević on 26/01/2013.
//  Copyright (c) 2013 Nenad Kovačević. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
