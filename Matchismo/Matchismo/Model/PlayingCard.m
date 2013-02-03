//
//  PlayingCard.m
//  Matchismo
//
//  Created by Nenad Kovačević on 26/01/2013.
//  Copyright (c) 2013 Nenad Kovačević. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard
@synthesize suit = _suit; //we must synthesize this property because we are declaring both getter and setter methods ourselves

// overriding match: method
// implemented in such a way that it doesn't matter how many cards should be matched
- (int)match:(NSArray *)otherCards
{
    int score = 0;      // final score
    int rankScore = 0;  // shows how many rank matches are there
    int suitScore = 0;  // shows how many suit matches are there
    
    NSMutableArray *otherPlayingCards = [[NSMutableArray alloc] init]; // array in which playing cards to be matched will be stored
    
    // introspection to see whether otherCard is a PlayingCard
    for (id otherCard in otherCards)
    {
        if ([otherCard isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
            [otherPlayingCards addObject:otherPlayingCard];
        }
    }
    
    // if there are cards to be matched, we match them
    if ([otherPlayingCards count])
    {
        // matching every card in array to the last flipped card
        for (PlayingCard *otherPlayingCard in otherPlayingCards)
        {
            if ([otherPlayingCard.suit isEqualToString:self.suit])
            {
                suitScore++; // incrementing suitScore if there is a suit match
            }
            else if (otherPlayingCard.rank == self.rank)
            {
                rankScore++; // incrementing rankScore if there is a rank match
            }
            
            // if there was a rank match, rankScore should be equal to number of otherPlayingCards
            if (rankScore == [otherPlayingCards count])
            {
                score = 4 * ([otherPlayingCards count]);
            }
            // if there was a suit match, suitScore should be equal to number of otherPlayingCards
            else if (suitScore == [otherPlayingCards count])
            {
                score = 1 * ([otherPlayingCards count]);
                // original scoring was kept, but in case of multiple cards matching
                // it is multiplied by the number of otherPlayingCards
            }
        }
    }
    return score;
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@end
